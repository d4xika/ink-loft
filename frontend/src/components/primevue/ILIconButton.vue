<script setup>
const props = defineProps({
  text: {
    type: String,
    default: undefined,
  },
  icon: {
    type: String,
    default: undefined,
  },
  image: {
    type: String,
    default: undefined,
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
    :icon="props.image ? undefined : `pi ${props.icon}`"
    class="icon-button"
    :class="`variant-${props.variant} color-${props.color}`"
  >
    <img
      v-if="props.image"
      :src="props.image"
      class="button-image"
      alt="read icon"
    />
  </Button>
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

  .button-image {
    height: 60px;
    object-fit: contain;
  }
}
</style>
