<script setup>
import { onBeforeUnmount, ref } from "vue";
import { useI18n } from "vue-i18n";
import { useRouter } from "vue-router";
import API from "@/helper/api.js";

const props = defineProps({
  friendUsername: {
    type: String,
    default: null,
  },
});
const emit = defineEmits(["confetti"]);

const { t } = useI18n();
const router = useRouter();

const user = JSON.parse(localStorage.getItem("user"));
const friend = ref(null);
let usernameClickCount = 0;
let usernameClickTimer;

if (props.friendUsername) {
  API.get("/friendships").then((response) => {
    friend.value = response.data.friends.find(
      ({ username }) => username === props.friendUsername,
    );
  });
}

function handleUsernameClick() {
  usernameClickCount += 1;
  clearTimeout(usernameClickTimer);

  if (usernameClickCount === 3) {
    usernameClickCount = 0;
    emit("confetti");
    return;
  }

  usernameClickTimer = setTimeout(() => {
    usernameClickCount = 0;
  }, 1000);
}

onBeforeUnmount(() => clearTimeout(usernameClickTimer));
</script>

<template>
  <div class="header-container">
    <div v-if="props.friendUsername">
      <ILIconButton
        icon="pi-chevron-left"
        variant="square"
        @click="router.push({ name: 'profile' })"
      />
    </div>
    <div v-else class="left-container">
      <ILAvatar
        :image="user.avatar_url.small"
        class="avatar-image-filter"
        @click="router.push({ name: 'profile' })"
      />
      <div class="text-container">
        <h4 class="welcome">
          {{ t("home.cozy_day") }}
        </h4>
        <button class="username" type="button" @click="handleUsernameClick">
          {{ user.username }}
        </button>
      </div>
    </div>
    <ILAvatar
      v-if="friend"
      class="avatar-image-filter"
      :image="friend.avatar_url"
      :username="friend.username"
    />
  </div>
</template>

<style scoped>
.header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: var(--gap-2);

  .left-container {
    display: flex;
    gap: var(--gap-2);

    .text-container {
      display: flex;
      flex-direction: column;
      justify-content: space-between;

      .welcome {
        margin: 0;
        color: var(--text-color-1-light);
        font-size: var(--font-size-2);
        font-weight: lighter;
        padding-top: var(--gap-1);
      }

      .username {
        margin: 0;
        padding: 0;
        border: 0;
        background: none;
        color: inherit;
        cursor: pointer;
        font-family: inherit;
        font-size: var(--font-size-6);
        font-weight: bold;
        text-align: left;
      }
    }
  }
}
</style>
