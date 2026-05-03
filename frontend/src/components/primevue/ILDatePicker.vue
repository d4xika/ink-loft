<script setup>
const props = defineProps({
  label: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  }
});
const model = defineModel({ type: Date, default: null });
</script>

<template>
  <FloatLabel variant="on">
    <DatePicker
      v-model="model"
      :name="props.name"
      :input-id="props.label"
      show-icon
      icon-display="input"
    />
    <label>{{ props.label }}</label>
  </FloatLabel>
</template>

<style lang="scss" scoped>
.p-floatlabel {
  width: 100% !important;
}

.p-datepicker {
  width: 100% !important;
}

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

<style lang="scss">
.p-datepicker-panel {
  .p-datepicker-day-cell {
    .p-datepicker-day-selected {
      background: var(--color-3) !important;
      color: white !important;
    }
  }
}
</style>