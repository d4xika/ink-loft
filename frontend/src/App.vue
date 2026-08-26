<script setup>
import { computed } from "vue";
import { useI18n } from "vue-i18n";
import { useRoute } from "vue-router";

const route = useRoute();
const { t } = useI18n();

const friendUsername = computed(() => {
  const username = route.params.username || route.query.friend;
  return Array.isArray(username) ? username[0] : username || null;
});
</script>

<template>
  <ILToast />
  <div v-if="friendUsername" class="friend-island">
    {{ t("home.readings_of", { username: friendUsername }) }}
  </div>
  <router-view />
</template>

<style scoped>
.friend-island {
  position: fixed;
  top: max(var(--gap-3), env(safe-area-inset-top));
  left: 50%;
  z-index: 10;
  max-width: calc(100vw - 180px);
  padding: 10px var(--gap-3);
  overflow: hidden;
  transform: translateX(-50%);
  border: 1px solid rgba(218, 217, 217, 0.1);
  border-radius: 999px;
  background: #0d0b0a;
  box-shadow:
    inset 0 1px 0 rgba(255, 255, 255, 0.04),
    0 5px 14px rgba(0, 0, 0, 0.28);
  font-size: var(--font-size-2);
  font-weight: bold;
  line-height: 1;
  pointer-events: none;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
