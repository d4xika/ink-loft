<script setup>
const props = defineProps({
  text: {
    type: String,
    required: true,
  },
  icon: {
    type: String,
  },
});
</script>

<template>
  <div class="box-button-container">
    <p class="text">{{ props.text }}</p>
    <i :class="`pi ${props.icon}`" />
  </div>
</template>

<style scoped>
.box-button-container {
  background-color: var(--color-2);
  border-radius: var(--border-radius-1);
  padding: 0 var(--gap-3) var(--gap-3) var(--gap-3);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--gap-2);
  width: 100%;
  cursor: pointer;

  .text {
    line-height: 1;
    text-align: center;
  }
}
</style>
