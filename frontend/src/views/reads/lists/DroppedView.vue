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
const sortBy = ref("date");

function getReads(filters = {}) {
  reads.value = { loading: true };
  API.get("reads", {
    params: { reading_status: "dropped", ...filters },
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
      :title="t('read.reading_status.dropped')"
      image="/images/drawings/cat-books.png"
      readingStatus="dropped"
      :searchOpen="showSearch"
      :sortBy="sortBy"
      @toggle-search="toggleSearch"
      @search="getReads"
      @sort="sortBy = $event"
    />
    <ReadsList :reads="reads" :sortBy="sortBy" />
  </div>
</template>

<style scoped></style>
