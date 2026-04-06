<script setup>
import { useRouter } from "vue-router";

const router = useRouter();

const user = JSON.parse(localStorage.getItem("user"));
</script>

<template>
  <div class="header-container">
    <ILAvatar @click="router.push({ name: 'profile' })" />
    <h1>Cozy day, {{ user.username }}!</h1>
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
