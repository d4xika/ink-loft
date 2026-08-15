<script setup>
import { computed } from "vue";

const props = defineProps({
  quote: {
    type: String,
    default: "You look beautiful today!",
  },
  source: {
    type: String,
    default: "Your Mom",
  },
  refreshEnabled: {
    type: Boolean,
    default: false,
  },
  editEnabled: {
    type: Boolean,
    default: false,
  },
});

const emit = defineEmits(["edit", "refresh"]);

const escapedQuote = computed(() => {
  return `<div>"${props.quote.replaceAll("\n", "</br>")}"</div>`;
});
</script>

<template>
  <div class="quotes-container">
    <div v-if="props.editEnabled || props.refreshEnabled" class="edit-buttons">
      <i
        v-if="props.editEnabled"
        class="pi pi-pencil"
        @click="emit('edit')"
      ></i>
      <i
        v-if="props.refreshEnabled"
        class="pi pi-sync"
        @click="emit('refresh')"
      ></i>
    </div>
    <h2 class="quote" v-dompurify-html="escapedQuote"></h2>
    <h3 class="source">~ {{ props.source }}</h3>
  </div>
</template>

<style scoped>
.quotes-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100%;
  background-color: var(--color-2);
  border-radius: var(--border-radius-1);
  padding: var(--gap-4);
  gap: var(--gap-2);
  cursor: pointer;

  .edit-buttons {
    width: 100%;
    display: flex;
    justify-content: flex-end;
    color: var(--text-color-1-light);
    gap: var(--gap-3);
    margin-top: calc(var(--gap-2) * -1);
    margin-right: calc(var(--gap-2) * -1);
    margin-bottom: var(--gap-1);

    i {
      cursor: pointer;
    }
  }

  .quote {
    font-family: "Petit Formal Script", serif;
    font-size: var(--font-size-4);
    font-weight: normal;
    letter-spacing: 2px;
  }

  .source {
    text-align: right;
    width: calc(100% - 10%);
    margin-right: 10%;
    font-family: "Courier Prime", sans-serif;
    font-size: var(--font-size-2);
    font-weight: lighter;
    color: var(--text-color-1-light);
  }
}
</style>
