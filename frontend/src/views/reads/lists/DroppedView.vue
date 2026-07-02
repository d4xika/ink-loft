<script setup>
import Header from "./_components/Header.vue";
import ReadsList from "./_components/ReadsList.vue";
import { ref } from "vue";
import API from "@/helper/api.js";

const reads = ref({});

function getReads() {
  API.get("books", { params: { reading_status: "dropped" } }).then(
    (response) => {
      reads.value = response.data;
    },
    (error) => {
      //TODO: toasty
    },
  );
}

getReads();
</script>

<template>
  <div>
    <Header title="Dropped" />
    <ReadsList :reads="reads" />
  </div>
</template>

<style scoped></style>
