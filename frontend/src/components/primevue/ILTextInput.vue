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
  required: true,
});
</script>

<template>
  <FloatLabel variant="on">
    <Password
      v-if="props.type === 'password'"
      :name="props.name"
      v-model="model"
      toggleMask
      :feedback="false"
    />
    <InputText v-else v-model="model" :name="props.name" />
    <label>{{ props.label }}</label>
  </FloatLabel>
</template>

<style scoped>
.p-floatlabel {
  width: 100% !important;
}

:deep(.p-password) {
  display: flex;
}

:deep(.p-inputtext) {
  background-color: var(--color-0);
  border: 1px solid var(--color-2);
  font-size: 0.8rem;
  padding-top: 11px !important;
  width: 100% !important;

  &:enabled:focus {
    border: 1px solid var(--text-color-1);
  }
}

label {
  padding-top: 3px;
  background-color: var(--color-0) !important;
  color: var(--text-color-1) !important;
}
</style>
