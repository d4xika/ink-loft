<script setup>
import { useRouter } from "vue-router";

const router = useRouter();
</script>

<template>
  <div class="header-container">
    <ILIconButton
      @click="router.push({ name: 'home' })"
      icon="pi-chevron-left"
      variant="square"
    />
    <ILIconButton icon="pi-bell" variant="square" />
  </div>
</template>

<style scoped>
.header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--gap-3);
}
</style>
