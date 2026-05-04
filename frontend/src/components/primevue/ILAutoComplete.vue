<script setup>
import { ref } from "vue";
import API from "../../helper/api.js";

const props = defineProps({
  suggestions: {
    type: Array,
    default: () => [],
  },
  name: {
    type: String,
    required: true,
  },
  optionLabel: {
    type: String,
    default: undefined,
  },
  url: {
    type: String,
    required: true,
  },
});

const model = defineModel({ type: [Object, String], default: null });

const items = ref([]);

function search(event) {
  API.get(props.url, {
    params: {
      term: event.query,
    },
  }).then((response) => {
    items.value = response.data;
  });
}
</script>

<template>
  <FloatLabel variant="on">
    <AutoComplete
      v-model="model"
      :suggestions="items"
      :name="props.name"
      :optionLabel="props.optionLabel"
      fluid
      @complete="search"
    />
    <label>Select a book</label>
  </FloatLabel>
</template>

<style scoped>
:deep(.p-inputtext) {
  background-color: var(--color-0);
  border: 1px solid var(--color-2);
  font-size: var(--font-size-3);
  padding-top: 11px !important;
  width: 100% !important;

  &:enabled:focus {
    border: 1px solid var(--text-color-1);
  }
}

label {
  padding-top: 3px;
  background-color: var(--color-0) !important;
  color: var(--text-color-1-light) !important;
}
</style>
