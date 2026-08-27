<script setup>
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { useToast } from "primevue/usetoast";
import { computed, ref, onMounted, nextTick } from "vue";
import { useI18n } from "vue-i18n";
import { useRoute, useRouter } from "vue-router";
import { z } from "zod";
import CurrentlyReading from "./_components/CurrentlyReading.vue";
import Header from "./_components/Header.vue";
import Updates, { UPDATE_VERSION } from "./_components/Updates.vue";
import { useLottieAnimation } from "@/composables/useLottieAnimation.js";
import API from "@/helper/api.js";

const { t } = useI18n();
const toast = useToast();
const router = useRouter();
const route = useRoute();
const friendUsername = computed(() => route.params.username || null);
const isFriendView = computed(() => Boolean(friendUsername.value));
const friendQuery = computed(() =>
  isFriendView.value ? { friend: friendUsername.value } : {},
);
const currentUser = JSON.parse(localStorage.getItem("user"));
const updateStorageKey = `ink-loft:updates-read:${currentUser?.username || "anonymous"}`;
const showUpdateButton = ref(
  localStorage.getItem(updateStorageKey) !== UPDATE_VERSION,
);
const updatesDrawer = ref(false);
const swipeContainer = ref(null);
const addQuote = ref(false);
const trackRead = ref(false);
const activeRead = ref(null);
const dailyQuote = ref(null);
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

const reads = ref({ loading: true });

function progressTotal(read, type) {
  if (type === "percentage") return 100;
  if (type === "chapters") return read.chapters ?? "";
  if (type === "pages") return read.pages ?? "";
  return "";
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

function markUpdatesRead() {
  localStorage.setItem(updateStorageKey, UPDATE_VERSION);
  showUpdateButton.value = false;
  updatesDrawer.value = false;
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
        toast.add({
          severity: "error",
          message: t("read.load_error"),
          life: 3000,
        });
        return;
      }

      reads.value = response.data;
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
    () => {},
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
      :showUpdates="showUpdateButton"
      @confetti="showConfetti"
      @open-updates="updatesDrawer = true"
    />
    <div class="content-container">
      <div
        class="clickable-quote"
        @click="
          router.push(
            isFriendView
              ? { name: 'friendQuotes', params: { username: friendUsername } }
              : { name: 'quotes' },
          )
        "
      >
        <ILQuotes
          :quote="dailyQuote?.content"
          :source="`${dailyQuote?.read?.title || 'Your Mom'}${dailyQuote?.read?.author ? `, ${dailyQuote?.read?.author}` : ''}`"
        />
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
            <div v-if="!isFriendView" class="swipe-actions">
              <ILAddItem
                text="Add New Read"
                variant="vertical"
                @click="router.push({ name: 'newRead' })"
              />
            </div>

            <div v-if="reads.length <= 0" class="no-reads-image-container">
              <img
                src="/images/drawings/kitty_on_shelf.png"
                alt="Kitty on shelf"
              />
            </div>

            <div v-if="reads.loading">
              <div class="skeleton-container">
                <Skeleton width="100px" height="150px" />
                <div class="skeleton-column">
                  <Skeleton width="120px" height="2rem" />
                  <Skeleton width="120px" height="3rem" />
                </div>
              </div>
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
                :readonly="isFriendView"
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
                    query: friendQuery,
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
            @click="router.push({ name: 'wantToRead', query: friendQuery })"
          />
          <ILBoxButton
            :text="t('home.have_read')"
            image="/images/drawings/have-read.png"
            @click="router.push({ name: 'haveRead', query: friendQuery })"
          />
        </div>
        <ILBoxButton
          :text="t('home.graveyard')"
          image="/images/drawings/gravestone.png"
          @click="router.push({ name: 'dropped', query: friendQuery })"
        />
      </div>
    </div>

    <ILDrawer v-if="!isFriendView" v-model="addQuote" :title="t('quotes.add')">
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

    <ILDrawer
      v-if="!isFriendView"
      v-model="trackRead"
      :title="t('home.track_read')"
    >
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

    <ILDrawer
      v-if="!isFriendView"
      v-model="finishRead"
      :title="t('home.finish_read')"
    >
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
        <Updates />
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
  </div>
</template>

<style scoped>
.home-view-container {
  display: flex;
  flex-direction: column;
  padding: var(--gap-3);

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
        font-family: "IM Fell English", serif;
        font-size: var(--font-size-6);
        padding-left: var(--gap-3);
        margin: 0;
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

    .box-container {
      display: flex;
      flex-direction: column;

      .box-buttons-container {
        display: flex;
        justify-content: center;
        gap: var(--gap-3);
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
</style>
