<script setup>
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { ref, onMounted } from "vue";
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
    (response) => {
      addQuote.value = false;
      // TODO: add toasti
    },
    (error) => {
      // TODO: add toasti
    },
  );
}

function loadDailyQuote() {
  API.get("quotes/daily_quote").then(
    (response) => {
      dailyQuote.value = response.data;
    },
    (error) => {},
  );
}

const resolver = zodResolver(
  z.object({
    quote: z.string().min(1, "Quote is required."),
  }),
);

onMounted(() => {
  if (swipeContainer.value) {
    swipeContainer.value.scrollLeft = swipeContainer.value.scrollWidth;
  }
});

loadDailyQuote();
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

      <div ref="swipeContainer" class="swipe-wrapper">
        <div class="swipe-actions">
          <ILBoxButton text="Add read" icon="pi-plus" />
          <ILBoxButton
            text="New read"
            icon="pi-plus"
            @click="router.push({ name: 'newBook' })"
          />
        </div>

        <div class="swipe-main">
          <CurrentlyReading
            title="Lunch baby"
            author="Me"
            @add-quote="
              activeBook = 1;
              addQuote = true;
            "
          />
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

    .swipe-wrapper {
      display: flex;
      overflow-x: auto;
      scroll-snap-type: x mandatory;
      gap: var(--gap-3);

      scrollbar-width: none;
      &::-webkit-scrollbar {
        display: none;
      }

      .swipe-actions {
        display: flex;
        flex-direction: column;
        justify-content: center;
        margin-top: var(--gap-4);
        gap: var(--gap-2);
        flex-shrink: 0;
        scroll-snap-align: start;
      }

      .swipe-main {
        flex-shrink: 0;
        scroll-snap-align: end;
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
