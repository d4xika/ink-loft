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
    default: "",
  },
});
</script>

<template>
  <Button class="text-button" :class="`variant-${props.variant}`">{{
    props.text
  }}</Button>
</template>

<style scoped>
.text-button {
  background-color: var(--color-3);
  border: 1px solid var(--color-0);
  color: var(--text-color-1);
  padding: 10px 0 7px 0;

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
