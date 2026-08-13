<script setup>
const props = defineProps({
  cover: {
    type: String,
    required: true,
    default: "/images/drawings/default_cover.png",
  },
  loading: {
    type: Boolean,
    default: false,
  },
});
</script>

<template>
  <div class="read-cover">
    <div class="read-cover-container">
      <Skeleton v-if="props.loading" class="cover-skeleton" />
      <img v-else :src="props.cover" alt="Read cover" />
    </div>
  </div>
</template>

<style scoped>
.read-cover {
  width: 100%;
  max-width: 200px;
}

.read-cover-container {
  width: 100%;
  aspect-ratio: 2 / 2.8;
  background-color: var(--color-2);
  border-radius: var(--border-radius-1);
  overflow: hidden;

  .cover-skeleton {
    width: 100% !important;
    height: 100% !important;
    border-radius: var(--border-radius-1);
  }

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-radius: var(--border-radius-1);
  }
}
</style>
