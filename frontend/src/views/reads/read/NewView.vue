<script setup>
import ReadForm from "./ReadForm.vue";
import API from "../../../helper/api.js";
import router from "../../../router/router.js";

const initRead = {
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

function saveRead(data) {
  if (!data.valid) {
    // TODO: add toasti
    return;
  }

  const formData = new FormData();

  const book = {};
  Object.keys(data.states).forEach((state) => {
    book[`${state}`] = data.states[state].value;
  });

  formData.append("book", JSON.stringify(book));

  if (data.coverImage) {
    formData.append("cover", data.coverImage);
  }

  API.post("books", formData, {
    headers: {
      "Content-Type": "multipart/form-data",
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
  <div>
    <div class="read-new-view">
      <ReadForm :initialValues="initRead" @save="(read) => saveRead(read)" />
    </div>
  </div>
</template>

<style scoped>
.read-new-view {
  padding: var(--gap-3);
}
</style>
