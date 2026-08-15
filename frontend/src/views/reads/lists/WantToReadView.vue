<script setup>
import { useToast } from "primevue/usetoast";
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import Header from "./_components/Header.vue";
import ReadsList from "./_components/ReadsList.vue";
import API from "@/helper/api.js";

const { t } = useI18n();
const toast = useToast();
const reads = ref({ loading: true });
const showSearch = ref(false);

function getReads(filters = {}) {
  reads.value = { loading: true };
  API.get("reads", {
    params: { reading_status: "want_to_read", ...filters },
  }).then(
    (response) => {
      reads.value = response.data;
    },
    () => {
      toast.add({
        severity: "error",
        message: t("read.load_error"),
        life: 3000,
      });
    },
  );
}

function toggleSearch() {
  showSearch.value = !showSearch.value;
  if (!showSearch.value) getReads();
}

getReads();
</script>

<template>
  <div>
    <Header
      title="Want to read"
      image="/images/drawings/dragon.png"
      readingStatus="want_to_read"
      :searchOpen="showSearch"
      @toggle-search="toggleSearch"
      @search="getReads"
    />
    <ReadsList :reads="reads" />
  </div>
</template>

<style scoped></style>
