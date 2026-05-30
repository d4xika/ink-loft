<script setup>
const props = defineProps({
  name: {
    type: String,
    default: "rating",
  },
  editEnabled: {
    type: Boolean,
    default: false,
  },
});
const model = defineModel({ type: Number, default: 0 });
</script>

<template>
  <Rating v-model="model" :name="props.name" :disabled="!props.editEnabled" />
</template>

<style scoped>
.p-rating {
  opacity: 1 !important;
}

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
