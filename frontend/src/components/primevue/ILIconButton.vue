<script setup>
const props = defineProps({
  text: {
    type: String,
    default: undefined,
  },
  icon: {
    type: String,
    required: true,
  },
  variant: {
    type: String,
    default: "full-width",
  },
  color: {
    type: String,
    default: "primary",
    validator: (value) => ["primary", "red", "brown"].includes(value),
  },
});
</script>

<template>
  <Button
    :icon="`pi ${props.icon}`"
    class="icon-button"
    :class="`variant-${props.variant} color-${props.color}`"
  />
</template>

<style scoped>
.p-button {
  background-color: var(--color-3);
  border: 1px solid transparent;
  color: var(--text-color-1);
  padding: 10px;

  &.variant-full-width {
    width: 100%;
    height: 100%;
  }

  &.color-primary {
    background-color: var(--color-3);
  }

  &.color-red {
    background-color: var(--color-1);
  }

  &.color-brown {
    background-color: var(--color-6);
  }

  &:hover {
    background-color: var(--color-3) !important;
    border: 1px solid var(--text-color-1-light) !important;
    color: var(--text-color-1) !important;
  }
}
</style>
