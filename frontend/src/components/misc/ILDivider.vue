<script setup>
const props = defineProps({
  width: {
    type: Number,
    default: 80,
  },
});
</script>

<template>
  <div
    class="divider"
    :style="`width: ${props.width}%; margin-left: ${(100 - props.width) / 2}%`"
  ></div>
</template>

<style scoped>
.divider {
  height: 1px;
  background-color: var(--text-color-1-light);
}
</style>
