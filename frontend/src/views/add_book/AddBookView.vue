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
          <ILTextInput label="Title" name="title" />
          <ILTextInput label="Author" name="author" />
        </div>
        <ILImageUploader variant="rectangle" title="Cover" name="cover" />
      </div>
      <!-- TODO: maybe change to combobox -->
      <ILTextInput label="Platform" name="platform" />
      <ILTextInput label="Pairing" name="pairing" />
      <ILNumberInput label="Chapters" name="chapters" />
      <ILNumberInput label="Words" name="words" />
      <ILNumberInput label="Pages" name="pages" />
      <!-- TODO add date-->
      <!-- TODO: maybe change to stars -->
      <ILTextInput label="Rating" name="rating" />
      <!-- TODO: maybe change to bool -->
      <ILTextInput label="Recommended?" name="recommended" />
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
    }
  }
}
</style>
