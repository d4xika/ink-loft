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
  },
});
const model = defineModel({ type: String, default: "" });
const emit = defineEmits(["change"]);
</script>

<template>
  <FloatLabel variant="on">
    <Select
      v-model="model"
      :options="props.options"
      :optionLabel="props.optionLabel"
      :optionValue="props.optionValue"
      @change="(event) => emit('change', event)"
    >
      <template #value="slotProps">
        <div v-if="slotProps.value?.image" class="line-container">
          <img :src="slotProps.value?.image" alt="flag" class="image" />
          <p>{{ slotProps.value?.[props.optionLabel] }}</p>
        </div>
      </template>
      <template #option="slotProps">
        <div v-if="slotProps.option?.image" class="line-container">
          <img :src="slotProps.option?.image" alt="flag" class="image" />
          <p>{{ slotProps.option?.[props.optionLabel] }}</p>
        </div>
      </template>
    </Select>
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
  padding: 2px !important;

  &:not(.p-disabled).p-focus {
    border: 1px solid var(--text-color-1) !important;
  }
}

label {
  padding-top: 3px;
  background-color: var(--color-0) !important;
  color: var(--text-color-1-light) !important;
}

.line-container {
  display: flex;
  align-items: center;
  gap: var(--gap-3);

  p {
    margin: 0;
    padding-top: 3px;
  }

  .image {
    width: 18px;
    border-radius: 2px;
  }
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
