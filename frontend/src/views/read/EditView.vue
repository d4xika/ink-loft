<script setup>
import { ref } from "vue";
import ReadForm from "./ReadForm.vue";
import { useRoute } from "vue-router";
import API from "../../helper/api.js";
import router from "../../router/router.js";

const route = useRoute();

const readInitValues = ref({});

const isLoaded = ref(false);

function getReadData() {
  API.get(`books/${route.params.id}`).then((response) => {
    readInitValues.value = response.data;
    readInitValues.value.rating = parseInt(readInitValues.value.rating);
    readInitValues.value.recommended = readInitValues.value.recommended === "t";
    isLoaded.value = true;
  });
}

function saveRead(data) {
  if (!data.valid) {
    // TODO: add toasti
    return;
  }

  const read = {};
  Object.keys(data.states).forEach((state) => {
    read[state] = data.states[state].value;
  });

  API.put(`books/${route.params.id}`, read).then((response) => {
    router.push({ name: "home" });
  });
}

getReadData();
</script>

<template>
  <div>
    <ReadForm
      v-if="isLoaded"
      @save="(read) => saveRead(read)"
      :initialValues="readInitValues"
    />
  </div>
</template>

<style scoped></style>
