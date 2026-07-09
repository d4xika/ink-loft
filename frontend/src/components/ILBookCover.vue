<script setup>
const props = defineProps({
  cover: {
    type: String,
    required: true,
    default: "/default_cover.png",
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
  width: 100%;
  max-width: 200px;
  aspect-ratio: 2 / 2.8;
  background-color: var(--color-2);
  border-radius: var(--border-radius-1);
  overflow: hidden;

  img {
    width: 100%;
    height: 100%;
    object-fit: contain;
    border-radius: var(--border-radius-1);
  }
}
</style>
