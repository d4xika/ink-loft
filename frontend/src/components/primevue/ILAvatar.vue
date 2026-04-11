<script setup>
import { ref } from "vue";

const props = defineProps({
  image: {
    type: String,
    default: undefined,
  },
});

const user = ref({});
if (!props.image) {
  user.value = JSON.parse(localStorage.getItem("user"));
}
</script>

<template>
  <Avatar
    :image="props.image"
    :label="user.username?.charAt(0).toUpperCase()"
    size="large"
    :class="{'no-image': !props.image}"
  />
</template>

<style scoped>
.p-avatar {
  background-color: var(--color-3) !important;
  color: var(--text-color-1);
  border-radius: var(--border-radius-1);
  cursor: pointer;

  &.no-image {
    padding-top: 4px !important;
  }
}

:deep(img) {
  border-radius: var(--border-radius-1);
}
</style>
