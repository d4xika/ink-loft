<script setup>
import Header from "./Header.vue";
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { z } from "zod";
import API from "@/helper/api.js";
import { useRouter } from "vue-router";

const router = useRouter();

const initBook = {
  title: null,
  author: null,
  cover: null,
  platform: null,
  pairing: null,
  chapters: null,
  words: null,
  pages: null,
  rating: null,
  recommended: null,
};

const resolver = zodResolver(
  z.object({
    title: z.string().min(1, "Title is required."),
    author: z.string().nullable(),
    cover: z.string().nullable(),
    platform: z.string().nullable(),
    pairing: z.string().nullable(),
    chapters: z.coerce.number().nullable(),
    words: z.coerce.number().nullable(),
    pages: z.coerce.number().nullable(),
    rating: z.string().nullable(),
    start_date: z.coerce.date().nullable(),
    end_date: z.coerce.date().nullable(),
    recommended: z.boolean().nullable(),
  }),
);

function submit(data) {
  console.log(data);
  if (!data.valid) {
    // TODO: add toasti
    return;
  }

  API.post("books", {
    book: {
      title: data.states.title.value,
      author: data.states.author?.value,
      cover: data.states.cover?.value,
      platform: data.states.platform?.value,
      pairing: data.states.pairing?.value,
      chapters: data.states.chapters?.value,
      words: data.states.words?.value,
      pages: data.states.pages?.value,
      rating: data.states.rating?.value,
      recommended: data.states.recommended?.value,
      start_date: data.states.start_date?.value,
      end_date: data.states.end_date?.value,
    },
  }).then(
    (response) => {
      router.push({ name: "home" });
      // TODO: add toasti
    },
    (error) => {
      // TODO: add toasti
    },
  );
}
</script>

<template>
  <Form :initialValues="initBook" :resolver="resolver" @submit="submit">
    <Header />
    <div class="content-container">
      <div class="main-content-container">
        <div class="title-author-container">
          <img src="/divider_book.png" alt="divider">
          <ILTextInput label="Title" name="title" />
          <ILTextInput label="Author" name="author" />
        </div>
        <div class="rating-section">
          <ILImageUploader variant="rectangle" title="Cover" name="cover" />
          <ILRating name="rating"/>
        </div>
      </div>
      <!-- TODO: maybe change to combobox -->
      <ILTextInput label="Platform" name="platform" />
      <ILTextInput label="Pairing" name="pairing" />
      <ILNumberInput label="Chapters" name="chapters" />
      <ILNumberInput label="Words" name="words" />
      <ILNumberInput label="Pages" name="pages" />
      <div class="side-by-side">
        <ILDatePicker label="Start Date" name="start_date" />
        <ILDatePicker label="End Date" name="end_date" />
      </div>
      <ILToggleSwitch label="Would recommend:" name="recommended"/>
      <!-- TODO: maybe change to area -->
      <ILTextInput label="Notes" name="notes" />
      <ILTextInput label="Link" name="link" />
      <!-- TODO add cool reading status box buttons?-->
    </div>
  </Form>
</template>

<style scoped>
.content-container {
  display: flex;
  flex-direction: column;
  gap: var(--gap-3);
  padding: var(--gap-3);

  .side-by-side {
    display: flex;
    gap: var(--gap-3);
  }

  .rating-section {
    display: flex;
    flex-direction: column;
    gap: var(--gap-3);
    padding-bottom: calc(var(--gap-1) + 2px)
  }

  .main-content-container {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: end;

    .title-author-container {
      display: flex;
      flex-direction: column;
      gap: var(--gap-3);
      width: 100%;
      padding-right: var(--gap-3);

      img {
        padding-left: var(--gap-3);
        padding-right: var(--gap-3);
        width: calc(100%);
      };
    }
  }
}
</style>
