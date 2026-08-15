<script setup>
import { onBeforeUnmount, ref, watch } from "vue";
import { useI18n } from "vue-i18n";
import { useRouter } from "vue-router";

const props = defineProps({
  title: {
    type: String,
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
});
const emit = defineEmits(["toggle-search", "search"]);

const router = useRouter();
const { t } = useI18n();
const searchTerm = ref("");
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
</script>

<template>
  <div class="header-container">
    <ILIconButton
      icon="pi-chevron-left"
      variant="square"
      @click="router.push({ name: 'home' })"
    />

    <div class="content-image-container">
      <img
        v-if="props.image"
        :src="props.image"
        class="header-image"
        alt="header icon"
      />

      <div class="title-plus-container">
        <h1>{{ props.title }}</h1>
        <div class="action-buttons">
          <ILIconButton
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
          <div class="search-action">
            <ILIconButton
              :icon="props.searchOpen ? 'pi-times' : 'pi-search'"
              variant="square"
              @click="emit('toggle-search')"
            />
            <div v-if="props.searchOpen" class="search-form">
              <ILTextInput
                v-model="searchTerm"
                :label="t('read.title_or_author')"
                name="search"
              />
            </div>
          </div>
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
    align-items: flex-end;
    gap: var(--gap-3);

    .title-plus-container {
      display: flex;
      flex-direction: column;
      gap: var(--gap-2);
      align-items: flex-start;
      flex: 1;
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

    .header-image {
      height: 100px;
      object-fit: contain;
    }
  }

  h1 {
    margin: 0;
  }

  .search-form {
    width: min(220px, 45vw);
  }
}

@media (max-width: 600px) {
  .header-container .search-form {
    width: min(180px, 42vw);
  }
}
</style>
