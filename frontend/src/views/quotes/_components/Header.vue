<script setup>
import { useToast } from "primevue/usetoast";
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import { useRouter } from "vue-router";
import API from "@/helper/api.js";

const props = defineProps({
  friendUsername: {
    type: String,
    default: null,
  },
});
const emit = defineEmits(["friendsLoaded", "reloadQuotes"]);

const toast = useToast();
const { t } = useI18n();
const router = useRouter();
const readonly = Boolean(props.friendUsername);
const quoteLibrarySettings = ref(false);
const friends = ref([]);
const user = JSON.parse(localStorage.getItem("user"));
const sharedFriendIds = user?.quotes_share_with_friends ?? [];
const initialValues = ref({});

function goBack() {
  router.push(
    props.friendUsername
      ? {
          name: "friendHome",
          params: { username: props.friendUsername },
        }
      : { name: "home" },
  );
}

function getFriends() {
  API.get("/friendships").then(
    (response) => {
      friends.value = response.data.friends;
      emit("friendsLoaded", friends.value);
      initialValues.value = Object.fromEntries(
        friends.value.map((friend) => [
          friend.user_id,
          sharedFriendIds.includes(friend.user_id),
        ]),
      );
    },
    () => {
      toast.add({
        severity: "error",
        message: t("general.generic_error"),
        life: 3000,
      });
    },
  );
}

function saveSettings(data) {
  const sharedUserIds = Object.entries(data.values)
    .filter(([, enabled]) => enabled)
    .map(([userId]) => Number(userId));

  API.put("/users/update_quotes_share_with_friends", {
    quotes_share_with_friends: sharedUserIds,
  }).then((response) => {
    user.quotes_share_with_friends = response.data.quotes_share_with_friends;
    localStorage.setItem("user", JSON.stringify(user));
    toast.add({
      severity: "success",
      message: t("quotes.settings_save_success"),
      life: 3000,
    });
    quoteLibrarySettings.value = false;
    emit("reloadQuotes");
  });
}

getFriends();
</script>

<template>
  <div class="header-container">
    <ILIconButton icon="pi-chevron-left" variant="square" @click="goBack" />
    <ILIconButton
      v-if="!readonly"
      icon="pi-users"
      variant="square"
      @click="quoteLibrarySettings = true"
    />

    <ILDrawer
      v-if="!readonly"
      v-model="quoteLibrarySettings"
      :title="t('quotes.sharing_settings')"
    >
      <template #body>
        <Form
          :initialValues="initialValues"
          class="flex flex-col gap-2"
          @submit="saveSettings"
        >
          <div
            v-for="friend in friends"
            :key="friend.id"
            class="flex flex-row gap-2"
          >
            <ILAvatar
              class="sharing-avatar avatar-image-filter"
              :image="friend.avatar_url || undefined"
              :username="friend.username"
            />
            <ILToggleSwitch
              v-model="initialValues[friend.user_id]"
              :label="friend.username"
              :name="`${friend.user_id}`"
              style="width: 100%"
            />
          </div>
          <ILTextButton :text="t('quotes.save_settings')" type="submit" />
        </Form>
      </template>
    </ILDrawer>
  </div>
</template>

<style scoped>
.header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--gap-3);
}

.sharing-avatar {
  flex: 0 0 auto;
}
</style>
