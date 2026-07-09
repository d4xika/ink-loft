<script setup>
import Header from "./_components/Header.vue";
import ReadsList from "./_components/ReadsList.vue";
import { ref } from "vue";
import API from "@/helper/api.js";
import { useToast } from "primevue/usetoast";
import { useI18n } from "vue-i18n";

const { t } = useI18n();
const toast = useToast();
const reads = ref({});

function getReads() {
  API.get("books", { params: { reading_status: "have_read" } }).then(
    (response) => {
      reads.value = response.data;
    },
    (error) => {
      toast.add({
        severity: "error",
        message: t("read.load_error"),
        life: 3000,
      });
    },
  );
}

getReads();
</script>

<template>
  <div>
    <Header title="Have read" image="/dragon-moon.png" />
    <ReadsList :reads="reads" />
  </div>
</template>

<style scoped></style>
