<script setup>
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { ref, onMounted, nextTick } from "vue";
import { useI18n } from "vue-i18n";
import { useRouter } from "vue-router";
import { z } from "zod";
import CurrentlyReading from "./_components/CurrentlyReading.vue";
import Header from "./_components/Header.vue";
import API from "@/helper/api.js";
import { useToast } from "primevue/usetoast";

const { t } = useI18n();
const toast = useToast();
const router = useRouter();
const swipeContainer = ref(null);
const addQuote = ref(false);
const activeRead = ref(null);
const dailyQuote = ref(null);
const showIndicator = ref(false);
const showLeftIndicator = ref(false);
const firstRead = ref(null);
const finishRead = ref(false);
const finishedReadInitialValues = ref({});

const reads = ref({ loading: true });

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
  };
  finishRead.value = true;
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
      end_date: new Date().toJSON(),
    },
  }).then(
    () => {
      finishRead.value = false;
      loadCurrentlyReading();
      toast.add({
        severity: "success",
        message: t("read.save_success"),
        life: 3000,
      });
    },
    (error) => {
      toast.add({
        severity: "error",
        message: t("general.generic_error"),
        life: 3000,
      });
    },
  );
}

function loadDailyQuote() {
  API.get("quotes/daily_quote").then(
    (response) => {
      dailyQuote.value = response.data;
    },
    () => {},
  );
}

function loadCurrentlyReading() {
  API.get("reads/currently_reading").then(
    (response) => {
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

const resolver = zodResolver(
  z.object({
    quote: z.string().min(1, "Quote is required."),
  }),
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
    <Header />
    <div class="content-container">
      <div @click="router.push({ name: 'quotes' })">
        <ILQuotes
          :quote="dailyQuote?.content"
          :source="dailyQuote?.read?.author"
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
            <div class="swipe-actions">
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
              v-else
              v-for="(read, index) in reads"
              :key="read.id"
              :ref="
                (el) => {
                  if (index === 0) firstRead = el;
                }
              "
              class="swipe-main"
            >
              <CurrentlyReading
                :title="read.title"
                :author="read.author"
                :coverImageUrl="read.cover_small_url"
                @addQuote="
                  activeRead = read.id;
                  addQuote = true;
                "
                @editRead="
                  router.push({ name: 'editRead', params: { id: read.id } })
                "
                @finishRead="openFinishReadDrawer(read)"
                @showRead="
                  router.push({ name: 'showRead', params: { id: read.id } })
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

    <ILDrawer v-model="addQuote" :title="t('quotes.add')">
      <template #body>
        <Form
          :resolver="resolver"
          class="quote-drawer-form"
          @submit="saveQuote"
        >
          <ILTextArea name="quote" :label="t('quotes.quote')" />
          <ILTextButton :text="t('quotes.save')" type="submit" />
        </Form>
      </template>
    </ILDrawer>

    <ILDrawer v-model="finishRead" :title="t('home.finish_read')">
      <template #body>
        <Form
          class="finish-read-form"
          @submit="saveFinishedRead"
          :initialValues="finishedReadInitialValues"
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
            name="rating"
            v-model="finishedReadInitialValues.rating"
            :editEnabled="true"
          />
          <ILToggleSwitch
            name="recommended"
            :label="t('read.would_recommend')"
            v-model="finishedReadInitialValues.recommended"
            class="toggle-switch"
          />
          <ILTextButton text="Submit" type="submit" />
        </Form>
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

.quote-drawer-form {
  display: flex;
  flex-direction: column;
  gap: var(--gap-3);
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
</style>
