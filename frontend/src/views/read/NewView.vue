<script setup>
import ReadForm from "./ReadForm.vue";
import API from "../../helper/api.js";
import router from "../../router/router.js";

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

  const read = {};
  Object.keys(data.states).forEach((state) => {
    read[state] = data.states[state].value;
  });

  API.post("books", {
    book: read,
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
    <ReadForm @save="(read) => saveRead(read)" :initialValues="initRead" />
  </div>
</template>

<style scoped></style>
