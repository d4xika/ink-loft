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
  color: {
    type: String,
    default: "primary",
    validator: (value) => ["primary", "red", "transparent"].includes(value),
  },
  disabled: {
    type: Boolean,
    default: false,
  },
});
</script>

<template>
  <Button
    :class="`variant-${props.variant} color-${props.color}`"
    :type="props.type"
    :disabled="props.disabled"
  >
    {{ props.text }}
  </Button>
</template>

<style scoped>
.p-button {
  border: 1px solid transparent !important;
  color: var(--text-color-1);
  padding: 8px 10px 5px 10px;
  white-space: nowrap;
  font-size: var(--font-size-3);

  &.variant-full-width {
    width: 100%;
  }

  &.color-primary {
    background-color: var(--color-3);
  }

  &.color-red {
    background-color: var(--color-1);
  }

  &.color-transparent {
    border: 1px solid var(--color-3) !important;
    background-color: transparent;
  }

  &:hover {
    background-color: var(--color-3) !important;
    border: 1px solid var(--text-color-1-light) !important;
    color: var(--text-color-1-light) !important;
  }
}
</style>
