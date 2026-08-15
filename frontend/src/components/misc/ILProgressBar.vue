<script setup>
const props = defineProps({
  value: {
    type: Number,
    default: 0,
  },
  showValue: {
    type: Boolean,
    default: false,
  },
});
</script>

<template>
  <ProgressBar :value="props.value" :showValue="props.showValue" />
</template>

<style scoped>
.p-progressbar {
  height: 0.5rem;
  background-color: var(--color-2);
}
</style>
