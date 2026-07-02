<script setup>
import { useRouter } from "vue-router";

const props = defineProps({
  title: {
    type: String,
    required: true,
  },
});

const router = useRouter();
</script>

<template>
  <div class="header-container">
    <ILIconButton
      icon="pi-chevron-left"
      variant="square"
      @click="router.push({ name: 'home' })"
    />

    <h1>{{ props.title }}</h1>

    <ILIconButton
      icon="pi-plus"
      variant="square"
      color="brown"
      @click="router.push({ name: 'newRead' })"
    />

    <ILDivider />
  </div>
</template>

<style scoped>
.header-container {
  display: flex;
  flex-direction: column;
  padding: var(--gap-3);
  gap: var(--gap-4);
}
</style>
