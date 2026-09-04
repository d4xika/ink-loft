<script setup>
import { onBeforeUnmount } from "vue";
import { useRouter } from "vue-router";

const props = defineProps({
  friendUsername: {
    type: String,
    default: null,
  },
});
const emit = defineEmits(["confetti"]);

const router = useRouter();

const user = JSON.parse(localStorage.getItem("user"));
let usernameClickCount = 0;
let usernameClickTimer;

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
          Cozy day,
        </h4>
        <button class="username" type="button" @click="handleUsernameClick">
          {{ user.username }}
        </button>
      </div>
    </div>
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
