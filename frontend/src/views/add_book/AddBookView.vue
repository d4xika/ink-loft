<script setup>
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { useRouter } from "vue-router";
import { z } from "zod";
import Header from "./Header.vue";
import ILSelect from "../../components/primevue/ILSelect.vue";
import API from "@/helper/api.js";
import { READING_STATUSES } from "@/helper/constants.js";

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
    start_date: z.coerce.date().nullable().optional(),
    end_date: z.coerce.date().nullable().optional(),
    recommended: z.boolean().nullable(),
    reading_status: z.coerce.number().nullable(),
  }),
);

function submit(data) {
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
      reading_status: data.states.status?.value,
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
          <img src="/divider_book.png" alt="divider" />
          <ILTextInput label="Title" name="title" />
          <ILTextInput label="Author" name="author" />
        </div>
        <div class="rating-section">
          <ILImageUploader variant="rectangle" title="Cover" name="cover" />
          <ILRating name="rating" />
        </div>
      </div>
      <ILSelect
        :options="READING_STATUSES"
        optionLabel="label"
        optionValue="id"
        label="Reading Status"
        name="reading_status"
      />
      <div class="side-by-side">
        <ILDatePicker label="Start Date" name="start_date" />
        <ILDatePicker label="End Date" name="end_date" />
      </div>
      <ILToggleSwitch label="Would recommend:" name="recommended" />
      <!-- TODO: maybe change to combobox -->
      <ILTextInput label="Platform" name="platform" />
      <ILNumberInput label="Chapters" name="chapters" />
      <ILNumberInput label="Words" name="words" />
      <ILNumberInput label="Pages" name="pages" />
      <ILTextInput label="Pairing" name="pairing" />
      <ILTextArea label="Notes" name="notes" />
      <ILTextInput label="Link" name="link" />
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
    padding-bottom: calc(var(--gap-1) + 2px);
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
      }
    }
  }
}
</style>
