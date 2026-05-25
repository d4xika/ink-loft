<script setup>
import { computed } from "vue";

const props = defineProps({
  label: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
});
const model = defineModel({ default: null });

const dateValue = computed({
  get() {
    if (!model.value) return null;
    if (typeof model.value === "string") {
      const date = new Date(model.value);
      return isNaN(date.getTime()) ? null : date;
    }
    return model.value;
  },
  set(newValue) {
    if (newValue instanceof Date) {
      const offset = newValue.getTimezoneOffset();
      const adjustedDate = new Date(newValue.getTime() - offset * 60 * 1000);
      model.value = adjustedDate.toISOString().split("T")[0];
    } else {
      model.value = newValue;
    }
  },
});
</script>

<template>
  <FloatLabel variant="on">
    <DatePicker
      updateModelType="string"
      v-model="dateValue"
      :name="props.name"
      :inputId="props.label"
      showIcon
      iconDisplay="input"
      dateFormat="dd-mm-yy"
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
  .p-datepicker-day-selected,
  .p-datepicker-month-selected,
  .p-datepicker-year-selected {
    background: var(--color-3) !important;
    color: white !important;
  }
}
</style>
