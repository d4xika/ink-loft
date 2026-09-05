<script setup>
import { computed } from "vue";

const props = defineProps({
  image: {
    type: String,
    default: undefined,
  },
  username: {
    type: String,
    default: undefined,
  },
});

const localUsername = JSON.parse(localStorage.getItem("user"))?.username;
const fallbackInitial = computed(() =>
  (props.username || localUsername)?.charAt(0).toUpperCase(),
);
</script>

<template>
  <Avatar
    :image="props.image"
    :label="props.image ? undefined : fallbackInitial"
    size="large"
    :class="{
      'avatar-image-filter': props.image,
      'no-image': !props.image,
    }"
  />
</template>

<style scoped>
.p-avatar {
  background-color: var(--color-3) !important;
  color: var(--text-color-1);
  border-radius: var(--border-radius-1);
  aspect-ratio: 1/1 !important;

  &.no-image {
    padding-top: 4px !important;
  }
}

:deep(img) {
  border-radius: var(--border-radius-1);
}
</style>
