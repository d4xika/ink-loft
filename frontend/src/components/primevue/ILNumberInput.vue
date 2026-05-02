<script setup>
const props = defineProps({
  label: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  type: {
    type: String,
    default: "text",
  },
});

const model = defineModel({
  type: String,
  required: false,
});
</script>

<template>
  <FloatLabel variant="on">
    <InputNumber v-model="model" :name="props.name" />
    <label>{{ props.label }}</label>
  </FloatLabel>
</template>

<style scoped>
.p-floatlabel {
  width: 100% !important;

  label {
    padding-top: 3px !important;
    background-color: var(--color-0) !important;
    color: var(--text-color-1-light) !important;
  }
}

:deep(.p-inputnumber) {
  width: 100% !important;

  .p-inputtext {
    background-color: var(--color-0);
    border: 1px solid var(--color-2);
    font-size: var(--font-size-3);
    padding-top: 11px !important;

    &:enabled:focus {
      border: 1px solid var(--text-color-1);
    }
  }
}
</style>
