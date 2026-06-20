<script setup>
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { ref, onMounted, nextTick } from "vue";
import { useI18n } from "vue-i18n";
import { useRouter } from "vue-router";
import { z } from "zod";
import CurrentlyReading from "./_components/CurrentlyReading.vue";
import Header from "./_components/Header.vue";
import ILBoxButton from "../../components/ILBoxButton.vue";
import ILDrawer from "../../components/primevue/ILDrawer.vue";
import ILTextArea from "../../components/primevue/ILTextArea.vue";
import IlQuotes from "../../components/quote/ILQuotes.vue";
import API from "../../helper/api.js";

const { t } = useI18n();
const router = useRouter();
const swipeContainer = ref(null);
const addQuote = ref(false);
const activeBook = ref(null);
const dailyQuote = ref(null);
const showIndicator = ref(false);
const showLeftIndicator = ref(false);
const firstBook = ref(null);
const finishRead = ref(false);
const finishedReadInitialValues = ref({});

const books = ref([]);

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
      book_id: activeBook.value,
      content: form.values.quote,
    },
  }).then(
    () => {
      addQuote.value = false;
      // TODO: add toasti
    },
    () => {
      // TODO: add toasti
    },
  );
}

function openFinishReadDrawer(book) {
  activeBook.value = book.id;
  finishedReadInitialValues.value = {
    reading_status: "have_read",
    rating: book.rating,
    recommended: book.recommended,
  };
  finishRead.value = true;
}

function saveFinishedRead(form) {
  if (!form.valid) {
    return;
  }

  API.put(`books/${activeBook.value}`, {
    book: {
      reading_status: form.values.reading_status,
      rating: form.values.rating,
      recommended: form.values.recommended,
      end_date: new Date().toJSON(),
    },
  }).then(() => {
    finishRead.value = false;
    loadCurrentlyReading();
  });
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
  API.get("books/currently_reading").then(
    (response) => {
      books.value = response.data;
      nextTick(() => {
        if (swipeContainer.value && firstBook.value) {
          firstBook.value.scrollIntoView({
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
        <IlQuotes
          :quote="dailyQuote?.content"
          :source="dailyQuote?.book?.author"
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

            <div v-if="books.length <= 0" class="no-books-image-container">
              <img src="/kitty_on_shelf.png" alt="Kitty on shelf" />
            </div>

            <div
              v-for="(book, index) in books"
              :key="book.id"
              :ref="
                (el) => {
                  if (index === 0) firstBook = el;
                }
              "
              class="swipe-main"
            >
              <CurrentlyReading
                :title="book.title"
                :author="book.author"
                :coverImageUrl="book.cover_url"
                @addQuote="
                  activeBook = book.id;
                  addQuote = true;
                "
                @editRead="
                  router.push({ name: 'editRead', params: { id: book.id } })
                "
                @finishRead="openFinishReadDrawer(book)"
                @showRead="
                  router.push({ name: 'showRead', params: { id: book.id } })
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
            icon="pi-bookmark"
            @click="router.push({ name: 'reads' })"
          />
          <ILBoxButton :text="t('home.have_read')" icon="pi-book" />
        </div>
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
          <ILRating name="rating" v-model="finishedReadInitialValues.rating" />
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

      .no-books-image-container {
        height: var(--read-cover-height);

        img {
          height: 70%;
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
