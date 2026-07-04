<script setup>
const props = defineProps({
  color: {
    type: String,
    default: "green",
    validator: (value) =>
      [
        "green",
        "red",
        "brown-1",
        "brown-2",
        "brown-3",
        "brown-4",
        "white",
      ].includes(value),
  },
  text: {
    type: [String, Number],
    required: true,
  },
  icon: {
    type: String,
    default: undefined,
  },
  size: {
    type: String,
    default: "small",
    validator: (value) => ["small", "big"].includes(value),
  },
});
</script>

<template>
  <div :class="`color-${props.color} size-${props.size}`" class="tag">
    <div v-if="props.icon" class="icon-container">
      <i :class="`pi ${props.icon}`" class="icon"></i>
    </div>
    <p class="text">{{ props.text }}</p>
  </div>
</template>

<style scoped>
.tag {
  display: flex;
  align-items: center;
  overflow: hidden;
  word-break: break-word;
  color: var(--text-color);

  &.color-green {
    background-color: var(--color-3);
  }

  &.color-red {
    background-color: var(--color-1);
  }

  &.color-white {
    background-color: var(--text-color-1-light);
    color: var(--color-0);
  }

  &.color-brown-1 {
    background-color: var(--color-7);
  }

  &.color-brown-2 {
    background-color: var(--color-4);
  }

  &.color-brown-3 {
    background-color: var(--color-5);
  }

  &.color-brown-4 {
    background-color: var(--color-6);
  }

  &.size-small {
    gap: var(--gap-2);
    padding: var(--gap-1) calc(var(--gap-1) + var(--gap-2));
    border-radius: var(--border-radius-2);

    .icon-container {
      display: flex;
      align-items: center;
      justify-content: center;

      .icon {
        font-size: var(--font-size-2);
        margin-top: 1px;
      }
    }

    .text {
      margin: 0;
      padding-top: 1px;
      font-size: var(--font-size-2);
    }
  }

  &.size-big {
    gap: var(--gap-2);
    padding: var(--gap-1) calc(var(--gap-1));
    width: 100%;
    border-radius: var(--border-radius-1);

    .icon-container {
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: color-mix(in srgb, black 45%, var(--color-3));
      padding: calc(var(--gap-1) + var(--gap-2));
      border-radius: var(--border-radius-1);

      .icon {
        font-size: var(--font-size-3);
      }
    }

    .text {
      margin: 0;
      padding-top: 3px;
      font-size: var(--font-size-4);
    }
  }
}
</style>
