<script setup>
const props = defineProps({
  cover: {
    type: String,
    required: true,
  },
});
</script>

<template>
  <div class="book-cover-container">
    <img :src="props.cover" alt="Book cover" />
  </div>
</template>

<style scoped>
.book-cover-container {
  max-width: 200px;
  height: 100%;

  img {
    width: 100%;
    height: 100%;
    border-radius: var(--border-radius-1);
  }
}
</style>
