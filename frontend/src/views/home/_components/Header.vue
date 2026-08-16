<script setup>
import { useI18n } from "vue-i18n";
import { useRouter } from "vue-router";

const props = defineProps({
  friendUsername: {
    type: String,
    default: null,
  },
});

const router = useRouter();
const { t } = useI18n();

const user = JSON.parse(localStorage.getItem("user"));
</script>

<template>
  <div class="header-container">
    <ILIconButton
      v-if="props.friendUsername"
      icon="pi-chevron-left"
      variant="square"
      @click="router.push({ name: 'profile' })"
    />
    <ILAvatar
      v-else
      :image="user.avatar_url.small"
      class="avatar-image-filter"
      @click="router.push({ name: 'profile' })"
    />
    <h1 v-if="props.friendUsername">
      {{ t("home.readings_of", { username: props.friendUsername }) }}
    </h1>
    <h1 v-else>Cozy day, {{ user.username }}!</h1>
  </div>
</template>

<style scoped>
.header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
