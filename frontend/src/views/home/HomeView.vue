<script setup>
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { useToast } from "primevue/usetoast";
import { computed, ref, onMounted, nextTick } from "vue";
import { useI18n } from "vue-i18n";
import { useRoute, useRouter } from "vue-router";
import { z } from "zod";
import CurrentlyReading from "./_components/CurrentlyReading.vue";
import Header from "./_components/Header.vue";
import Updates, { UPDATES } from "./_components/Updates.vue";
import { useLottieAnimation } from "@/composables/useLottieAnimation.js";
import API from "@/helper/api.js";

const { t } = useI18n();
const toast = useToast();
const router = useRouter();
const route = useRoute();
const friendUsername = computed(() => route.params.username || null);
const isFriendView = computed(() => Boolean(friendUsername.value));
const friendQuery = computed(() => ({ friend: friendUsername.value }));
const updatesSeenCount = ref(null);
const unreadUpdates = computed(() => {
  if (updatesSeenCount.value === null) return [];

  return UPDATES.slice(
    0,
    Math.max(UPDATES.length - updatesSeenCount.value, 0),
  );
});
const updatesDrawer = ref(false);
const swipeContainer = ref(null);
const addQuote = ref(false);
const trackRead = ref(false);
const activeRead = ref(null);
const dailyQuote = ref(null);
const dailyQuoteSource = computed(
  () =>
    `${dailyQuote.value?.read?.title || "Your Mom"}${
      dailyQuote.value?.read?.author ? `, ${dailyQuote.value.read.author}` : ""
    }`,
);
const showIndicator = ref(false);
const showLeftIndicator = ref(false);
const firstRead = ref(null);
const finishRead = ref(false);
const finishedReadInitialValues = ref({});
const trackReadInitialValues = ref({});
const trackForm = ref(null);
const {
  container: animationContainer,
  isPlaying: showAnimation,
  play: playAnimation,
} = useLottieAnimation();
const animationType = ref(null);
const FINISH_READ_REMOVAL_DELAY = 600;

const reads = ref([]);
const readsLoading = ref(true);

function progressTotal(read, type) {
  if (type === "percentage") return 100;
  if (type === "chapters") return read.chapters ?? "";
  if (type === "pages") return read.pages ?? "";
  return "";
}

function progressPercentage(read) {
  if (
    !read.progress_type ||
    read.current_progress === null ||
    read.current_progress === undefined
  ) {
    return null;
  }

  const total = progressTotal(read, read.progress_type);

  return total ? (read.current_progress / total) * 100 : null;
}

function handleScroll() {
  if (!swipeContainer.value) return;
  const { scrollLeft, scrollWidth, clientWidth } = swipeContainer.value;
  showIndicator.value = scrollLeft + clientWidth < scrollWidth - 10;
  showLeftIndicator.value = scrollLeft > 150;
}

function saveQuote(form) {
  if (!form.valid) {
    return;
  }
  API.post("quotes", {
    quote: {
      read_id: activeRead.value,
      content: form.values.quote,
    },
  }).then(
    () => {
      addQuote.value = false;
      toast.add({
        severity: "success",
        message: t("quotes.save_success"),
        life: 3000,
      });
    },
    () => {
      toast.add({
        severity: "error",
        message: t("general.generic_error"),
        life: 3000,
      });
    },
  );
}

function openFinishReadDrawer(read) {
  activeRead.value = read.id;
  finishedReadInitialValues.value = {
    reading_status: 2,
    rating: read.rating,
    recommended: read.recommended,
    notes: read.notes,
  };
  finishRead.value = true;
}

function openTrackReadDrawer(read) {
  activeRead.value = read.id;
  const inferredType =
    (read.current_progress !== null && read.current_progress !== undefined
      ? read.progress_type
      : null) ||
    (read.chapters ? "chapters" : read.pages ? "pages" : "percentage");
  trackReadInitialValues.value = {
    type: inferredType,
    max: progressTotal(read, inferredType),
    current: read.current_progress ?? "",
  };
  trackRead.value = true;
}

function showConfetti() {
  animationType.value = "confetti";
  playAnimation("/animations/Confetti.json");
}

async function loadUpdatesState() {
  try {
    const response = await API.get("users/updates_state");
    let seenCount = response.data.updates_seen_count;

    if (seenCount === null) {
      const initialSeenCount = Math.max(UPDATES.length - 1, 0);
      const initializeResponse = await API.put("users/mark_updates_read", {
        updates_seen_count: initialSeenCount,
      });
      seenCount = initializeResponse.data.updates_seen_count;
    }

    updatesSeenCount.value = seenCount;
  } catch {
    toast.add({
      severity: "error",
      message: t("general.generic_error"),
      life: 3000,
    });
  }
}

async function markUpdatesRead() {
  try {
    const response = await API.put("users/mark_updates_read", {
      updates_seen_count: UPDATES.length,
    });
    updatesSeenCount.value = response.data.updates_seen_count;
    updatesDrawer.value = false;
  } catch {
    toast.add({
      severity: "error",
      message: t("general.generic_error"),
      life: 3000,
    });
  }
}

function updateProgressType(type) {
  const read = reads.value.find((item) => item.id === activeRead.value);
  if (!read) return;

  trackForm.value?.setFieldValue("max", progressTotal(read, type));
}

function saveFinishedRead(form) {
  if (!form.valid) {
    return;
  }

  API.put(`reads/${activeRead.value}`, {
    read: {
      reading_status: form.values.reading_status,
      rating: form.values.rating,
      recommended: form.values.recommended,
      notes: form.values.notes,
      end_date: new Date().toJSON(),
    },
  }).then(
    () => {
      finishRead.value = false;
      if (form.values.reading_status === 2) {
        animationType.value = "confetti";
        playAnimation("/animations/Confetti.json");
      } else if (form.values.reading_status === 3) {
        animationType.value = "ghost";
        playAnimation("/animations/Ghost.json");
      }
      setTimeout(loadCurrentlyReading, FINISH_READ_REMOVAL_DELAY);
      toast.add({
        severity: "success",
        message: t("read.save_success"),
        life: 3000,
      });
    },
    () => {
      toast.add({
        severity: "error",
        message: t("general.generic_error"),
        life: 3000,
      });
    },
  );
}

function saveTrackRead(form) {
  if (!form.valid) {
    return;
  }
  const read = reads.value.find((r) => r.id === activeRead.value);
  if (!read) return;

  const current = Number(form.values.current);
  const max = Number(form.values.max);

  if (
    !Number.isInteger(current) ||
    (form.values.type !== "percentage" && !Number.isInteger(max))
  ) {
    toast.add({
      severity: "error",
      message: t("general.invalid_number"),
      life: 3000,
    });
    return;
  }

  const updateData = {
    progress_type: form.values.type,
    current_progress: current,
  };
  if (form.values.type === "chapters") {
    updateData.chapters = max;
  } else if (form.values.type === "pages") {
    updateData.pages = max;
  }

  API.put(`reads/${activeRead.value}`, {
    read: updateData,
  }).then(
    () => {
      trackRead.value = false;
      loadCurrentlyReading();
      toast.add({
        severity: "success",
        message: t("read.save_success"),
        life: 3000,
      });
    },
    () => {
      toast.add({
        severity: "error",
        message: t("general.generic_error"),
        life: 3000,
      });
    },
  );
}

function loadDailyQuote() {
  API.get("quotes/daily_quote", {
    params: { username: friendUsername.value || undefined },
  }).then(
    (response) => {
      dailyQuote.value = response.data;
    },
    () => {},
  );
}

function loadCurrentlyReading() {
  API.get("reads/currently_reading", {
    params: { username: friendUsername.value || undefined },
  }).then(
    (response) => {
      if (!Array.isArray(response.data)) {
        reads.value = [];
        readsLoading.value = false;
        toast.add({
          severity: "error",
          message: t("read.load_error"),
          life: 3000,
        });
        return;
      }

      reads.value = response.data;
      readsLoading.value = false;
      nextTick(() => {
        if (swipeContainer.value && firstRead.value) {
          firstRead.value.scrollIntoView({
            behavior: "auto",
            block: "nearest",
            inline: "center",
          });
          setTimeout(handleScroll, 100);
        }
      });
    },
    () => {
      readsLoading.value = false;
    },
  );
}

const quoteResolver = zodResolver(
  z.object({
    quote: z.string().min(1, "Quote is required."),
  }),
);

const progressInteger = z.preprocess(
  (value) =>
    value === null || (typeof value === "string" && value.trim() === "")
      ? undefined
      : value,
  z.coerce.number().int().nonnegative(),
);

const trackResolver = zodResolver(
  z
    .object({
      type: z.enum(["chapters", "pages", "percentage"]),
      max: progressInteger,
      current: progressInteger,
    })
    .refine(
      ({ type, max, current }) =>
        current <= (type === "percentage" ? 100 : max),
      { path: ["current"] },
    ),
);

onMounted(() => {
  if (swipeContainer.value) {
    swipeContainer.value.scrollLeft = 0;
    handleScroll();
  }
});

loadDailyQuote();
loadCurrentlyReading();
loadUpdatesState();
</script>

<template>
  <div class="home-view-container">
    <div
      v-if="showAnimation"
      ref="animationContainer"
      :class="[
        'lottie-overlay',
        { 'lottie-overlay--ghost': animationType === 'ghost' },
      ]"
    ></div>
    <Header
      :friendUsername="friendUsername"
      @confetti="showConfetti"
    />
    <Button
      v-if="!isFriendView && unreadUpdates.length"
      class="updates-button"
      type="button"
      :aria-label="`${t('home.updates')} (${unreadUpdates.length})`"
      @click="updatesDrawer = true"
    >
      <i class="pi pi-bell" aria-hidden="true"></i>
      <span>{{ t("home.updates") }}</span>
      <span class="updates-count">{{ unreadUpdates.length }}</span>
    </Button>
    <div v-if="isFriendView" class="friend-content-container">
      <section class="friend-section">
        <h2 class="section-title">
          {{ t("read.reading_status.currently_reading") }}
        </h2>

        <div v-if="readsLoading" class="friend-currently-reading">
          <div v-for="index in 2" :key="index" class="friend-read-card">
            <Skeleton width="100%" height="180px" />
            <Skeleton width="80%" height="1rem" />
          </div>
        </div>

        <div v-else-if="reads.length" class="friend-currently-reading">
          <button
            v-for="read in reads"
            :key="read.id"
            class="friend-read-card"
            type="button"
            @click="
              router.push({
                name: 'showRead',
                params: { id: read.id },
                query: friendQuery,
              })
            "
          >
            <ILReadCover
              :cover="read.cover_small_url ? read.cover_small_url : undefined"
            />
            <span class="friend-read-title">{{ read.title }}</span>
            <ILProgressBar
              v-if="progressPercentage(read) !== null"
              class="friend-progress-bar"
              :value="progressPercentage(read)"
            />
          </button>
        </div>

        <div v-else class="friend-empty-state">
          <img src="/images/drawings/kitty_on_shelf.png" alt="Kitty on shelf" />
        </div>
      </section>

      <section class="friend-section">
        <h2 class="section-title">
          {{ t("home.read_library") }}
        </h2>
        <div class="friend-library-grid">
          <ILBoxButton
            :text="t('home.want_to_read')"
            image="/images/drawings/read-list.png"
            @click="router.push({ name: 'wantToRead', query: friendQuery })"
          />
          <ILBoxButton
            :text="t('home.have_read')"
            image="/images/drawings/have-read.png"
            @click="router.push({ name: 'haveRead', query: friendQuery })"
          />
          <ILBoxButton
            :text="t('home.graveyard')"
            image="/images/drawings/gravestone.png"
            @click="router.push({ name: 'dropped', query: friendQuery })"
          />
        </div>
      </section>

      <section class="friend-section">
        <h2 class="section-title">
          {{ t("home.quote_library") }}
        </h2>
        <button
          class="friend-quote-card"
          type="button"
          @click="
            router.push({
              name: 'friendQuotes',
              params: { username: friendUsername },
            })
          "
        >
          <ILQuotes
            v-if="dailyQuote?.content"
            :quote="dailyQuote?.content"
            :source="dailyQuoteSource"
          />
          <span v-else class="friend-empty-quote">
            {{ t("quotes.no_quotes") }}
          </span>
        </button>
      </section>
    </div>

    <div v-else class="content-container">
      <div class="clickable-quote" @click="router.push({ name: 'quotes' })">
        <ILQuotes :quote="dailyQuote?.content" :source="dailyQuoteSource" />
      </div>
      <ILDivider />

      <div class="box-container">
        <p class="section-title">
          {{ t("read.reading_status.currently_reading") }}
        </p>
        <div class="swipe-container-relative">
          <div v-if="showLeftIndicator" class="swipe-indicator left">
            <i class="pi pi-angle-left"></i>
          </div>
          <div
            ref="swipeContainer"
            class="swipe-wrapper"
            @scroll="handleScroll"
          >
            <div class="swipe-actions">
              <ILAddItem
                text="Add New Read"
                variant="vertical"
                @click="router.push({ name: 'newRead' })"
              />
            </div>

            <div v-if="readsLoading">
              <div class="skeleton-container">
                <Skeleton width="100px" height="150px" />
                <div class="skeleton-column">
                  <Skeleton width="120px" height="2rem" />
                  <Skeleton width="120px" height="3rem" />
                </div>
              </div>
            </div>

            <div v-else-if="!reads.length" class="no-reads-image-container">
              <img
                src="/images/drawings/kitty_on_shelf.png"
                alt="Kitty on shelf"
              />
            </div>

            <div
              v-for="(read, index) in reads"
              v-else
              :key="read.id"
              :ref="
                (el) => {
                  if (index === 0) firstRead = el;
                }
              "
              class="swipe-main"
            >
              <CurrentlyReading
                :read="read"
                @add-quote="
                  activeRead = read.id;
                  addQuote = true;
                "
                @track-read="openTrackReadDrawer(read)"
                @finish-read="openFinishReadDrawer(read)"
                @show-read="
                  router.push({
                    name: 'showRead',
                    params: { id: read.id },
                  })
                "
              />
            </div>
          </div>
          <div v-if="showIndicator" class="swipe-indicator right">
            <i class="pi pi-angle-right"></i>
          </div>
        </div>
      </div>

      <ILDivider />
      <div class="box-container">
        <div class="box-buttons-container">
          <ILBoxButton
            :text="t('home.want_to_read')"
            image="/images/drawings/read-list.png"
            @click="router.push({ name: 'wantToRead' })"
          />
          <ILBoxButton
            :text="t('home.have_read')"
            image="/images/drawings/have-read.png"
            @click="router.push({ name: 'haveRead' })"
          />
        </div>
        <ILBoxButton
          :text="t('home.graveyard')"
          image="/images/drawings/gravestone.png"
          @click="router.push({ name: 'dropped' })"
        />
      </div>
    </div>

    <template v-if="!isFriendView">
      <ILDrawer v-model="addQuote" :title="t('quotes.add')">
        <template #body>
          <Form
            :resolver="quoteResolver"
            class="quote-drawer-form"
            @submit="saveQuote"
          >
            <ILTextArea name="quote" :label="t('quotes.quote')" />
            <ILTextButton :text="t('quotes.save')" type="submit" />
          </Form>
        </template>
      </ILDrawer>

      <ILDrawer v-model="trackRead" :title="t('home.track_read')">
        <template #body>
          <Form
            ref="trackForm"
            v-slot="$form"
            :resolver="trackResolver"
            class="track-drawer-form"
            :initialValues="trackReadInitialValues"
            @submit="saveTrackRead"
          >
            <div class="select-type">
              <ILSelectButton
                name="type"
                :options="[
                  { id: 'chapters', label: t('read.chapters') },
                  { id: 'pages', label: t('read.pages') },
                  { id: 'percentage', label: t('read.percentage') },
                ]"
                optionLabel="label"
                optionValue="id"
                @update:model-value="updateProgressType"
              />
            </div>

            <ILTextInput
              v-show="$form.type?.value !== 'percentage'"
              name="max"
              :label="t('read.total')"
              type="number"
            />

            <ILTextInput
              name="current"
              :label="t('read.current')"
              type="number"
            />

            <ILTextButton :text="t('home.track_progress')" type="submit" />
          </Form>
        </template>
      </ILDrawer>

      <ILDrawer v-model="finishRead" :title="t('home.finish_read')">
        <template #body>
          <Form
            class="finish-read-form"
            :initialValues="finishedReadInitialValues"
            @submit="saveFinishedRead"
          >
            <ILSelectButton
              name="reading_status"
              optionLabel="label"
              :options="[
                { id: 2, label: t('read.reading_status.finished') },
                { id: 3, label: t('read.reading_status.dropped') },
              ]"
              optionValue="id"
            />
            <ILRating
              v-model="finishedReadInitialValues.rating"
              name="rating"
              :editEnabled="true"
            />
            <ILToggleSwitch
              v-model="finishedReadInitialValues.recommended"
              name="recommended"
              :label="t('read.would_recommend')"
              class="toggle-switch"
            />
            <ILTextArea
              v-model="finishedReadInitialValues.notes"
              name="notes"
              :label="t('read.notes')"
            />
            <ILTextButton text="Submit" type="submit" />
          </Form>
        </template>
      </ILDrawer>

      <ILDrawer v-model="updatesDrawer" :title="t('home.updates')">
        <template #body>
          <Updates :updates="unreadUpdates" />
          <div class="updates-actions">
            <ILTextButton
              :text="t('home.read_updates')"
              variant="fit-content"
              @click="markUpdatesRead"
            />
            <ILTextButton
              :text="t('home.close_updates')"
              variant="fit-content"
              color="transparent"
              @click="updatesDrawer = false"
            />
          </div>
        </template>
      </ILDrawer>
    </template>
  </div>
</template>

<style scoped>
.home-view-container {
  display: flex;
  flex-direction: column;
  padding: var(--gap-3);

  .section-title {
    margin: 0;
    font-family: "IM Fell English", serif;
    font-size: var(--font-size-6);
    font-weight: normal;
  }

  .friend-content-container {
    display: flex;
    flex-direction: column;
    gap: var(--gap-4);
    margin-top: var(--gap-4);

    .friend-section {
      display: flex;
      flex-direction: column;
      gap: var(--gap-3);
      min-width: 0;
    }

    .friend-currently-reading {
      display: grid;
      grid-auto-columns: minmax(105px, 35%);
      grid-auto-flow: column;
      gap: var(--gap-3);
      padding-bottom: var(--gap-1);
      overflow-x: auto;
      scrollbar-width: none;

      &::-webkit-scrollbar {
        display: none;
      }
    }

    .friend-read-card,
    .friend-quote-card {
      padding: 0;
      border: 0;
      background: transparent;
      color: inherit;
      cursor: pointer;
      font: inherit;
      text-align: left;
    }

    .friend-read-card {
      display: flex;
      flex-direction: column;
      gap: var(--gap-2);
      min-width: 0;

      :deep(.read-cover-container) {
        width: 100%;
      }

      .friend-read-title {
        overflow: hidden;
        font-size: var(--font-size-2);
        text-overflow: ellipsis;
        white-space: nowrap;
      }

      .friend-progress-bar {
        width: 100%;
      }
    }

    .friend-empty-state {
      height: var(--read-cover-height);

      img {
        height: 70%;
      }
    }

    .friend-library-grid {
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: var(--gap-2);

      :deep(.box-button-container) {
        box-sizing: border-box;
        height: 100%;
        padding: var(--gap-2);
      }

      :deep(.text) {
        font-size: var(--font-size-2);
      }

      :deep(.image) {
        max-width: 100%;
        height: 48px;
      }
    }

    .friend-quote-card {
      width: 100%;
    }

    .friend-empty-quote {
      display: block;
      box-sizing: border-box;
      width: 100%;
      padding: var(--gap-4) var(--gap-3);
      border: 1px solid var(--color-2);
      border-radius: var(--border-radius-1);
      color: var(--text-color-1-light);
      text-align: center;
    }
  }

  .content-container {
    display: flex;
    flex-direction: column;
    margin-top: var(--gap-4);
    gap: var(--gap-4);

    .box-container {
      display: flex;
      flex-direction: column;
      gap: var(--gap-3);

      .section-title {
        padding-left: var(--gap-3);
      }

      .box-buttons-container {
        display: flex;
        justify-content: center;
        gap: var(--gap-3);
      }

      .swipe-container-relative {
        position: relative;
        display: flex;
        align-items: center;
        overflow-y: hidden;

        .swipe-indicator {
          position: absolute;
          top: 50%;
          transform: translateY(-50%);
          pointer-events: none;
          height: 100%;
          display: flex;
          align-items: center;
          color: var(--text-color-1-light);
          z-index: 1;

          &.right {
            right: 0;
            padding-left: var(--gap-4);
            padding-right: var(--gap-1);
          }

          &.left {
            left: 0;
            padding-right: var(--gap-4);
            padding-left: var(--gap-1);
          }
        }
      }
    }

    .swipe-wrapper {
      display: flex;
      overflow-x: auto;
      scroll-snap-type: x mandatory;
      gap: calc(var(--gap-5) * 2);
      width: 100%;
      padding-right: var(--gap-4);

      scrollbar-width: none;
      &::-webkit-scrollbar {
        display: none;
      }

      .swipe-actions {
        display: flex;
        flex-direction: column;
        justify-content: center;
        gap: var(--gap-2);
        flex-shrink: 0;
        scroll-snap-align: start;
        margin-right: calc(-1.7 * var(--gap-5));
      }

      .no-reads-image-container {
        height: var(--read-cover-height);

        img {
          height: 70%;
        }
      }

      .skeleton-container {
        display: flex;
        gap: var(--gap-2);

        .skeleton-column {
          display: flex;
          flex-direction: column;
          justify-content: flex-end;
          gap: var(--gap-2);
        }
      }

      .swipe-main {
        flex-shrink: 0;
        scroll-snap-align: center;
        width: calc(100% - 30px);
      }
    }
  }
}

.quote-drawer-form,
.track-drawer-form {
  display: flex;
  flex-direction: column;
  gap: var(--gap-3);

  .select-type {
    display: flex;
    justify-content: center;
  }
}

.finish-read-form {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--gap-4);

  .toggle-switch {
    width: 100%;
  }
}

.updates-actions {
  display: flex;
  justify-content: flex-end;
  gap: var(--gap-2);
  margin-top: var(--gap-3);
}

.updates-button {
  position: fixed;
  right: max(var(--gap-3), env(safe-area-inset-right));
  bottom: max(var(--gap-3), env(safe-area-inset-bottom));
  z-index: 10;
  gap: var(--gap-2);
  padding: 9px 12px;
  border: 1px solid var(--color-7);
  border-radius: 999px;
  background-color: var(--color-6);
  box-shadow: 0 5px 14px rgba(0, 0, 0, 0.28);
  color: var(--text-color-1);
  font-family: inherit;
  font-weight: bold;

  &:hover,
  &:focus-visible {
    border-color: var(--color-7) !important;
    background-color: var(--color-6) !important;
    box-shadow: 0 5px 14px rgba(0, 0, 0, 0.28) !important;
    color: var(--text-color-1) !important;
  }

  .updates-count {
    display: inline-flex;
    min-width: 1.25rem;
    height: 1.25rem;
    align-items: center;
    justify-content: center;
    padding: 0 var(--gap-1);
    border-radius: 999px;
    background: var(--color-7);
    font-size: var(--font-size-1);
    line-height: 1;
  }
}
</style>
