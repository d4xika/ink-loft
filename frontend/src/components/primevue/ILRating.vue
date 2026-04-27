<script setup>
const props = defineProps({
  name: {
    type: String,
    required: true,
  }
})
const model = defineModel({ type: Number, default: 0})
</script>

<template>
  <Rating v-model="model" :name="props.name"/>
</template>

<style scoped>
:deep(.p-rating-option) {
  transform: scale(1.5);
  margin-right: var(--gap-2);
}

:deep(.p-rating-option-active) {
    svg {
      color: var(--color-3) !important;
  }
}
</style>