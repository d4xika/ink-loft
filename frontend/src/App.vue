<script setup>
import { computed } from "vue";
import { useI18n } from "vue-i18n";
import { useRoute } from "vue-router";

const route = useRoute();
const { t } = useI18n();
const cachedListViews = ["WantToReadView", "HaveReadView", "DroppedView"];

const friendUsername = computed(() => {
  const username = route.params.username || route.query.friend;
  return Array.isArray(username) ? username[0] : username || null;
});
</script>

<template>
  <ILToast />
  <div v-if="friendUsername" class="friend-island">
    <p class="font-fix">
      {{ t("home.readings_of", { username: friendUsername }) }}
    </p>
  </div>
  <router-view v-slot="{ Component, route: currentRoute }">
    <KeepAlive :include="cachedListViews">
      <component :is="Component" :key="currentRoute.fullPath" />
    </KeepAlive>
  </router-view>
</template>

<style scoped>
.friend-island {
  position: fixed;
  top: max(calc(var(--gap-3) + var(--gap-2)), env(safe-area-inset-top));
  left: 50%;
  z-index: 10;
  max-width: calc(100vw - 180px);
  padding: var(--gap-2) var(--gap-3);
  overflow: hidden;
  transform: translateX(-50%);
  border: 1px solid rgba(218, 217, 217, 0.1);
  border-radius: 999px;
  background: var(--color-2);
  box-shadow:
    inset 0 1px 0 rgba(255, 255, 255, 0.04),
    0 5px 14px rgba(0, 0, 0, 0.28);
  font-size: var(--font-size-2);
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
