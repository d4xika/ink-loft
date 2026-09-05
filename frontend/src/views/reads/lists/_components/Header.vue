<script setup>
import { onBeforeUnmount, ref, watch } from "vue";
import { useI18n } from "vue-i18n";
import { useRouter } from "vue-router";

const props = defineProps({
  title: {
    type: String,
    required: true,
  },
  amount: {
    type: Number,
    required: true,
  },
  image: {
    type: String,
    default: undefined,
  },
  readingStatus: {
    type: String,
    default: undefined,
    validator: (value) =>
      ["want_to_read", "have_read", "dropped"].includes(value),
  },
  searchOpen: {
    type: Boolean,
    default: false,
  },
  sortBy: {
    type: String,
    default: "date",
    validator: (value) =>
      [
        "title",
        "author",
        "pairing",
        "date",
        "chapters",
        "pages",
        "words",
      ].includes(value),
  },
  sortDirection: {
    type: String,
    default: "desc",
    validator: (value) => ["asc", "desc"].includes(value),
  },
  readonly: {
    type: Boolean,
    default: false,
  },
  friendUsername: {
    type: String,
    default: null,
  },
});
const emit = defineEmits(["toggle-search", "search", "sort"]);

const router = useRouter();
const { t } = useI18n();
const searchTerm = ref("");
const sortOpen = ref(false);
const selectedSort = ref(props.sortBy);
const selectedSortDirection = ref(props.sortDirection);
let searchTimeout;

watch(searchTerm, () => {
  clearTimeout(searchTimeout);
  if (!props.searchOpen) return;

  searchTimeout = setTimeout(() => {
    emit("search", { search: searchTerm.value.trim() });
  }, 350);
});

watch(
  () => props.searchOpen,
  (searchOpen) => {
    if (!searchOpen) searchTerm.value = "";
  },
);

onBeforeUnmount(() => clearTimeout(searchTimeout));

function selectSort(value) {
  if (selectedSort.value === value) {
    selectedSortDirection.value =
      selectedSortDirection.value === "asc" ? "desc" : "asc";
  } else {
    selectedSort.value = value;
    selectedSortDirection.value = "asc";
  }

  emit("sort", {
    sortBy: selectedSort.value,
    sortDirection: selectedSortDirection.value,
    search: searchTerm.value.trim(),
  });
}

function sortButtonText(value, label) {
  if (selectedSort.value !== value) return label;

  return `${label} ${selectedSortDirection.value === "asc" ? "↑" : "↓"}`;
}
</script>

<template>
  <div class="header-container">
    <ILIconButton
      icon="pi-chevron-left"
      variant="square"
      @click="
        router.push(
          props.friendUsername
            ? {
                name: 'friendHome',
                params: { username: props.friendUsername },
              }
            : { name: 'home' },
        )
      "
    />

    <div class="content-image-container">
      <img
        v-if="props.image"
        :src="props.image"
        class="header-image"
        alt="header icon"
      />

      <div class="title-plus-container">
        <div class="title-amount">
          <h1>{{ props.title }}</h1>
          <p class="font-fix">[{{ props.amount }}]</p>
        </div>
        <div class="action-buttons">
          <ILIconButton
            v-if="!props.readonly"
            icon="pi-plus"
            variant="square"
            color="brown"
            @click="
              router.push({
                name: 'newRead',
                query: { status: props.readingStatus },
              })
            "
          />
          <div class="sort-action">
            <ILIconButton
              :icon="sortOpen ? 'pi-times' : 'pi-sort-amount-down'"
              variant="square"
              @click="sortOpen = !sortOpen"
            />
          </div>
          <div class="search-action">
            <ILIconButton
              :icon="props.searchOpen ? 'pi-times' : 'pi-search'"
              variant="square"
              @click="emit('toggle-search')"
            />
          </div>
        </div>
        <div v-if="props.searchOpen" class="search-form">
          <ILTextInput
            v-model="searchTerm"
            :label="t('read.title_or_author')"
            name="search"
          />
        </div>
        <div v-if="sortOpen" class="sort-menu">
          <ILTextButton
            :text="sortButtonText('title', t('read.title'))"
            variant="fit-content"
            :color="selectedSort === 'title' ? 'primary' : 'transparent'"
            @click="selectSort('title')"
          />
          <ILTextButton
            :text="sortButtonText('author', t('read.author'))"
            variant="fit-content"
            :color="selectedSort === 'author' ? 'primary' : 'transparent'"
            @click="selectSort('author')"
          />
          <ILTextButton
            :text="sortButtonText('pairing', t('read.pairing'))"
            variant="fit-content"
            :color="selectedSort === 'pairing' ? 'primary' : 'transparent'"
            @click="selectSort('pairing')"
          />
          <ILTextButton
            :text="sortButtonText('date', t('read.start_date'))"
            variant="fit-content"
            :color="selectedSort === 'date' ? 'primary' : 'transparent'"
            @click="selectSort('date')"
          />
          <ILTextButton
            :text="sortButtonText('chapters', t('read.chapters'))"
            variant="fit-content"
            :color="selectedSort === 'chapters' ? 'primary' : 'transparent'"
            @click="selectSort('chapters')"
          />
          <ILTextButton
            :text="sortButtonText('pages', t('read.pages'))"
            variant="fit-content"
            :color="selectedSort === 'pages' ? 'primary' : 'transparent'"
            @click="selectSort('pages')"
          />
          <ILTextButton
            :text="sortButtonText('words', t('read.words'))"
            variant="fit-content"
            :color="selectedSort === 'words' ? 'primary' : 'transparent'"
            @click="selectSort('words')"
          />
        </div>
      </div>
    </div>

    <ILDivider />
  </div>
</template>

<style scoped>
.header-container {
  display: flex;
  flex-direction: column;
  padding: var(--gap-3);
  gap: var(--gap-4);

  .content-image-container {
    display: flex;
    align-items: flex-start;
    gap: var(--gap-3);

    .title-plus-container {
      display: flex;
      flex-direction: column;
      gap: var(--gap-2);
      align-items: flex-start;
      flex: 1;

      .title-amount {
        display: flex;
        flex-direction: row;
        align-items: center;
        gap: var(--gap-2);
      }
    }

    .action-buttons {
      display: flex;
      align-items: center;
      gap: var(--gap-2);
    }

    .search-action {
      display: flex;
      align-items: center;
      gap: var(--gap-1);
    }

    .sort-action {
      display: flex;
    }

    .header-image {
      align-self: flex-start;
      height: 100px;
      object-fit: contain;
    }
  }

  h1 {
    margin: 0;
  }

  .search-form {
    width: 90%;
  }

  .sort-menu {
    display: flex;
    flex-wrap: wrap;
    gap: var(--gap-1);
  }
}
</style>
