<script setup>
import { useRouter } from "vue-router";
import API from "../../../helper/api.js";
import { setAuthStatus } from "../../../router/router.js";

const router = useRouter();

function logout() {
  API.put("users/logout").then(
    () => {
      setAuthStatus(false);
      router.push({ name: "authentication" });
    },
    () => {
      //TODO: toasty
    },
  );
}
</script>

<template>
  <div class="header-container">
    <ILIconButton
      icon="pi-chevron-left"
      variant="square"
      @click="router.push({ name: 'home' })"
    />
    <ILIconButton
      icon="pi-sign-out"
      variant="square"
      color="red"
      @click="logout()"
    />
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
