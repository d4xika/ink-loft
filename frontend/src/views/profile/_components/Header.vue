<script setup>
import { useRouter } from "vue-router";
import API from "../../../helper/api.js";
import { setAuthStatus } from "../../../router/router.js";
import { useToast } from "primevue/usetoast";
import { useI18n } from "vue-i18n";

const { t } = useI18n();
const router = useRouter();
const toast = useToast();

function logout() {
  API.put("users/logout").then(
    () => {
      setAuthStatus(false);
      router.push({ name: "authentication" });
    },
    () => {
      toast.add({
        severity: "error",
        message: t("authentication.logout_error"),
        life: 3000,
      });
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
