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
});

const model = defineModel({
  type: String,
  required: true,
});
</script>

<template>
  <FloatLabel variant="on">
    <InputText :id="props.name" v-model="model" />
    <label :for="props.name">{{ props.label }}</label>
  </FloatLabel>
</template>

<style scoped>
:deep(.p-inputtext) {
  background-color: var(--color-0);
}

label {
  padding-top: 3px;
}
</style>
