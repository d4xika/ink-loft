<script setup>
const props = defineProps({
  text: {
    type: String,
    required: true,
  },
  variant: {
    type: String,
    default: "full-width",
  },
  type: {
    type: String,
    default: undefined,
    validator: (value) => ["submit", undefined].includes(value),
  },
});
</script>

<template>
  <Button :class="`variant-${props.variant}`" :type="props.type">{{
    props.text
  }}</Button>
</template>

<style scoped>
.p-button {
  background-color: var(--color-3);
  border: 1px solid transparent !important;
  color: var(--text-color-1);
  padding: 9px 10px 6px 10px;
  white-space: nowrap;
  font-size: var(--font-size-3);

  &.variant-full-width {
    width: 100%;
  }

  &:hover {
    background-color: var(--color-3) !important;
    border: 1px solid var(--text-color-1-light) !important;
    color: var(--text-color-1) !important;
  }
}
</style>
