<script setup>
const props = defineProps({
  options: {
    type: Array,
    required: true,
  },
  label: {
    type: String,
    required: true,
  },
  optionLabel: {
    type: String,
    default: undefined,
  },
  optionValue: {
    type: String,
    default: undefined,
  }
})
const model = defineModel({ type: String, default: "" })
</script>

<template>
  <FloatLabel class="w-full md:w-56" variant="on">
    <Select
      v-model="model"
      :options="props.options"
      :option-label="props.optionLabel"
      :option-value="props.optionValue"
      class="w-full"
    />
    <label>{{ props.label }}</label>
  </FloatLabel>
</template>

<style scoped>
.p-floatlabel {
  width: 100% !important;
}

.p-select {
  width: 100% !important;
  background-color: var(--color-0);
  border: 1px solid var(--color-2);
  font-size: var(--font-size-3);
  padding: 11px !important;

  &:not(.p-disabled).p-focus {
    border: 1px solid var(--text-color-1) !important;
  }
}

label {
  padding-top: 3px;
  background-color: var(--color-0) !important;
  color: var(--text-color-1-light) !important;
}

</style>

<style lang="scss">
.p-select-overlay {
  background-color: var(--color-0) !important;
  border: 1px solid var(--color-2);

  .p-select-option {
    padding: var(--gap-3) !important;

    &[data-p-selected="true"] {
      background-color: var(--color-3) !important;
    }
  }
}
</style>