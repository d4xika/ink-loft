<script setup>
import { useRouter } from "vue-router";

const router = useRouter();
</script>

<template>
  <div class="header-container">
    <ILIconButton
      icon="pi-chevron-left"
      variant="square"
      @click="router.push({ name: 'home' })"
    />

    <h1>Want to read</h1>
  </div>
</template>

<style scoped>
.header-container {
  padding: var(--gap-3);
}
</style>
