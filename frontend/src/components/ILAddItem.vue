<script setup>
const props = defineProps({
  text: {
    type: String,
    required: true,
  },
  width: {
    type: String,
    default: "100%",
  },
  height: {
    type: String,
    default: "100%",
  },
  variant: {
    type: String,
    default: "horizontal",
    validator: (value) => ["horizontal", "vertical"].includes(value),
  },
});
</script>

<template>
  <div class="add-item" :class="`variant-${props.variant}`">
    <div class="add-item-icon">
      <i class="pi pi-plus"></i>
    </div>
    <p>{{ props.text }}</p>
  </div>
</template>

<style scoped>
.add-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
  width: v-bind(props.width);
  height: v-bind(props.height);
  padding: 0 var(--gap-2);
  background: repeating-linear-gradient(
    -45deg,
    var(--color-2),
    var(--color-2) 0.5px,
    transparent 2px,
    transparent 8px
  );
  border: 1px solid var(--color-2);
  border-radius: var(--border-radius-1);

  &.variant-vertical {
    flex-direction: column;
    padding: var(--gap-2);
    justify-content: center;
    gap: var(--gap-2);

    p {
      margin: 0;
    }

    .add-item-icon {
      order: 1;
    }
  }

  i {
    background-color: var(--color-0);
    border: 1px solid var(--color-2);
    padding: var(--gap-2);
    border-radius: var(--border-radius-1);
    font-size: var(--font-size-3);
  }

  p {
    background-color: var(--color-0);
    border-radius: var(--border-radius-1);
    border: 1px solid var(--color-2);
    padding: var(--gap-1) var(--gap-2);
    padding-top: 7px;
    width: fit-content;
    font-size: var(--font-size-2);
    text-align: center;
  }
}
</style>
