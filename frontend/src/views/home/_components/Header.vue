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
const hasNewActivity = ref(false);
const hasPendingFriendRequest = ref(false);
let usernameClickCount = 0;
let usernameClickTimer;

if (props.friendUsername) {
  API.get("/friendships").then((response) => {
    friend.value = response.data.friends.find(
      ({ username }) => username === props.friendUsername,
    );
  });
} else {
  API.get("/activities").then((response) => {
    hasNewActivity.value = response.data.some((activity) => activity.new);
  });
  API.get("/friendships").then((response) => {
    hasPendingFriendRequest.value = response.data.incoming_requests.length > 0;
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
    <ILIconButton
      v-if="props.friendUsername"
      icon="pi-chevron-left"
      variant="square"
      @click="router.push({ name: 'profile' })"
    />
    <div v-else class="left-container">
      <div
        class="profile-avatar"
        :class="{ 'has-pending-request-badge': hasPendingFriendRequest }"
      >
        <ILAvatar
          :image="user.avatar_url.small"
          class="avatar-image-filter"
          @click="router.push({ name: 'profile' })"
        />
      </div>
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
    <ILIconButton
      v-else-if="!props.friendUsername"
      class="activity-button"
      :class="{ 'has-new-badge': hasNewActivity }"
      icon="pi-bell"
      variant="square"
      color="transparent"
      @click="router.push({ name: 'activity' })"
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

    .profile-avatar {
      display: flex;
      position: relative;

      &.has-pending-request-badge::after {
        content: "";
        position: absolute;
        z-index: 1;
        top: -0.2rem;
        right: -0.2rem;
        width: 0.75rem;
        height: 0.75rem;
        border: 2px solid var(--color-0);
        border-radius: 50%;
        background-color: var(--color-1-bright);
        pointer-events: none;
      }
    }

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

  .activity-button {
    position: relative;

    &.has-new-badge::after {
      content: "";
      position: absolute;
      z-index: 1;
      top: 0;
      right: 0;
      width: 0.75rem;
      height: 0.75rem;
      border: 2px solid var(--color-0);
      border-radius: 50%;
      background-color: var(--color-1-bright);
      pointer-events: none;
    }
  }
}
</style>
