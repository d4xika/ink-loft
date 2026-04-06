<script setup>
const props = defineProps({
  icon: {
    type: String,
    required: true,
  },
});
</script>

<template>
  <Button :icon="`pi ${props.icon}`" class="icon-button" />
</template>

<style scoped>
.p-button {
  background-color: var(--color-3);
  border: 1px solid transparent;
  color: var(--text-color-1);
  padding: 10px;

  &.variant-full-width {
    width: 100%;
  }

  &:hover {
    background-color: var(--color-3) !important;
    border: 1px solid var(--p-inputtext-hover-border-color) !important;
    color: var(--text-color-1) !important;
  }
}
</style>
