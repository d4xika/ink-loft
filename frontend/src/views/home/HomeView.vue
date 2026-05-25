<script setup>
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { ref, onMounted, nextTick } from "vue";
import { useRouter } from "vue-router";
import { z } from "zod";
import CurrentlyReading from "./_components/CurrentlyReading.vue";
import Header from "./_components/Header.vue";
import ILBoxButton from "../../components/ILBoxButton.vue";
import ILDrawer from "../../components/primevue/ILDrawer.vue";
import ILTextArea from "../../components/primevue/ILTextArea.vue";
import IlQuotes from "../../components/quote/ILQuotes.vue";
import API from "../../helper/api.js";

const router = useRouter();
const swipeContainer = ref(null);
const addQuote = ref(false);
const activeBook = ref(null);
const dailyQuote = ref(null);
const showIndicator = ref(false);
const showLeftIndicator = ref(false);
const firstBook = ref(null);

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
        <p class="section-title">Currently Reading</p>
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
                @click="router.push({ name: 'newBook' })"
              />
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
                @add-quote="
                  activeBook = book.id;
                  addQuote = true;
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
          <ILBoxButton text="Want to read" icon="pi-bookmark" />
          <ILBoxButton text="Have read" icon="pi-book" />
        </div>
      </div>
    </div>

    <ILDrawer v-model="addQuote" title="Add Quote">
      <template #body>
        <Form
          :resolver="resolver"
          class="quote-drawer-form"
          @submit="saveQuote"
        >
          <ILTextArea name="quote" label="Quote" />
          <ILTextButton text="Save Quote" type="submit" />
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
</style>
