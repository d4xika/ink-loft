<script setup>
import { useToast } from "primevue/usetoast";
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import { useRoute } from "vue-router";
import Header from "./_components/Header.vue";
import ReadsList from "./_components/ReadsList.vue";
import { getSavedReadSort, saveReadSort } from "./readSort.js";
import API from "@/helper/api.js";

const { t } = useI18n();
const toast = useToast();
const route = useRoute();
const friendUsername = route.query.friend || null;
const reads = ref({ loading: true });
const showSearch = ref(false);
const savedSort = getSavedReadSort("dropped");
const sortBy = ref(savedSort.sortBy);
const sortDirection = ref(savedSort.sortDirection);

function updateSort({
  sortBy: nextSortBy,
  sortDirection: nextDirection,
  search,
}) {
  sortBy.value = nextSortBy;
  sortDirection.value = nextDirection;
  saveReadSort("dropped", nextSortBy, nextDirection);
  getReads({ search });
}

function getReads(filters = {}) {
  reads.value = { loading: true };
  API.get("reads", {
    params: {
      reading_status: "dropped",
      username: friendUsername || undefined,
      sort_by: sortBy.value,
      sort_direction: sortDirection.value,
      ...filters,
    },
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
      :amount="reads.length"
      image="/images/drawings/cat-books.png"
      readingStatus="dropped"
      :searchOpen="showSearch"
      :sortBy="sortBy"
      :sortDirection="sortDirection"
      :readonly="Boolean(friendUsername)"
      :friendUsername="friendUsername"
      @toggle-search="toggleSearch"
      @search="getReads"
      @sort="updateSort"
    />
    <ReadsList :reads="reads" :friendUsername="friendUsername" />
  </div>
</template>

<style scoped></style>
