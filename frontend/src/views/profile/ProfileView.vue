<script setup>
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { useToast } from "primevue/usetoast";
import { onMounted, ref } from "vue";
import { useI18n } from "vue-i18n";
import { useRouter } from "vue-router";
import { z } from "zod";
import Header from "./_components/Header.vue";
import API from "@/helper/api.js";
import { setTheme } from "@/helper/helper.js";
import { languages } from "@/helper/i18n/i18n.js";
import { REGEX } from "@/helper/regex.js";

const { locale, t } = useI18n();
const toast = useToast();
const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem("user")));
const avatarUrl = ref(user.value?.avatar_url.medium || null);
const avatarLoading = ref(false);
const addFriendDrawer = ref(false);
const friendUsername = ref("");
const friends = ref([]);
const incomingRequests = ref([]);
const outgoingRequests = ref([]);
const friendsLoading = ref(false);
const requestLoading = ref(false);
const accountLoading = ref(false);
const accountForm = ref({
  username: user.value?.username || "",
  email: user.value?.email || "",
  current_password: "",
  new_password: "",
  confirm_new_password: "",
});
const theme = ref(user.value?.theme || "dark");

const selectedLanguage = ref(
  languages.find((language) => language.value === user.value?.language) ||
    languages[0],
);

const accountResolver = zodResolver(
  z
    .object({
      username: z.string().trim().min(1, "Username is required."),
      email: z
        .string()
        .trim()
        .min(1, "Email is required.")
        .regex(REGEX.email, "Invalid email format."),
      current_password: z.string().min(1, "Current password is required."),
      new_password: z.string(),
      confirm_new_password: z.string(),
    })
    .refine(
      (data) =>
        !data.new_password || data.new_password === data.confirm_new_password,
      {
        message: "The new passwords do not match.",
        path: ["confirm_new_password"],
      },
    ),
);

function storeUser(updatedUser) {
  user.value = updatedUser;
  localStorage.setItem("user", JSON.stringify(updatedUser));
}

async function updateProfilePicture(file) {
  const formData = new FormData();
  formData.append("avatar", file);

  avatarLoading.value = true;

  try {
    const response = await API.put("/users/update_profile", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });

    storeUser(response.data.user);
    avatarUrl.value = response.data.user?.avatar_url.medium || null;
    toast.add({
      severity: "success",
      message: t("profile.avatar_update_success"),
      life: 3000,
    });
  } catch {
    toast.add({
      severity: "error",
      message: t("profile.update_error"),
      life: 3000,
    });
  } finally {
    avatarLoading.value = false;
  }
}
async function removeProfilePicture() {
  const formData = new FormData();

  formData.append("delete_avatar", "true");
  avatarLoading.value = true;

  API.put("/users/update_profile", formData)
    .then((response) => {
      storeUser(response.data.user);
      avatarUrl.value = response.data.user?.avatar_url.medium || null;
      toast.add({
        severity: "success",
        message: t("profile.avatar_remove_success"),
        life: 3000,
      });
    })
    .catch(() => {
      toast.add({
        severity: "error",
        message: t("profile.update_error"),
        life: 3000,
      });
    })
    .finally(() => {
      avatarLoading.value = false;
    });
}

function updateTheme(selectedTheme) {
  API.put("/users/update_profile", { theme: selectedTheme }).then(
    (response) => {
      storeUser(response.data.user);
      setTheme(response.data.user.theme);
      toast.add({
        severity: "success",
        message: t("profile.theme_update_success"),
        life: 3000,
      });
    },
    () => {
      theme.value = user.value.theme;
      toast.add({
        severity: "error",
        message: t("profile.theme_update_error"),
        life: 3000,
      });
    },
  );
}

function updateLanguage(event) {
  if (!event?.value?.value) return;
  locale.value = event.value.value;
  API.put("/users/update_profile", { language: event.value.value }).then(
    (response) => {
      storeUser(response.data.user);
      toast.add({
        severity: "success",
        message: t("profile.update_success"),
        life: 3000,
      });
    },
    () => {
      toast.add({
        severity: "error",
        message: t("profile.update_error"),
        life: 3000,
      });
    },
  );
}

async function updateAccount(data) {
  if (!data.valid) {
    toast.add({
      severity: "error",
      message: t("general.validation_error_detail"),
      life: 3000,
    });
    return;
  }

  accountLoading.value = true;
  try {
    const response = await API.put("/users/update_profile", {
      username: data.values.username,
      email: data.values.email,
      current_password: data.values.current_password,
      password: data.values.new_password,
    });

    storeUser(response.data.user);
    if (response.data.csrf_token) {
      API.defaults.headers.common["X-CSRF-Token"] = response.data.csrf_token;
    }
    accountForm.value.username = response.data.user.username;
    accountForm.value.email = response.data.user.email;
    accountForm.value.current_password = "";
    accountForm.value.new_password = "";
    accountForm.value.confirm_new_password = "";
    data.reset();
    toast.add({
      severity: "success",
      message: t("profile.account_update_success"),
      life: 3000,
    });
  } catch (error) {
    toast.add({
      severity: "error",
      message:
        error.response?.status === 403
          ? t("profile.current_password_error")
          : error.response?.status === 409
            ? t("authentication.register_error_conflict")
            : t("profile.update_error"),
      life: 3000,
    });
  } finally {
    accountLoading.value = false;
  }
}

async function loadFriendships() {
  friendsLoading.value = true;

  try {
    const response = await API.get("/friendships");
    friends.value = response.data.friends;
    incomingRequests.value = response.data.incoming_requests;
    outgoingRequests.value = response.data.outgoing_requests;
  } catch {
    toast.add({
      severity: "error",
      message: t("profile.friends_load_error"),
      life: 3000,
    });
  } finally {
    friendsLoading.value = false;
  }
}

async function addFriend() {
  const username = friendUsername.value.trim();
  if (!username) return;

  requestLoading.value = true;
  try {
    await API.post("/friendships", { username });
    friendUsername.value = "";
    addFriendDrawer.value = false;
    await loadFriendships();
    toast.add({
      severity: "success",
      message: t("profile.friend_request_sent"),
      life: 3000,
    });
  } catch (error) {
    const messageKey =
      error.response?.status === 404
        ? "profile.friend_not_found"
        : error.response?.status === 409
          ? "profile.friend_request_exists"
          : error.response?.status === 422
            ? "profile.cannot_add_yourself"
            : "general.generic_error";
    toast.add({ severity: "error", message: t(messageKey), life: 3000 });
  } finally {
    requestLoading.value = false;
  }
}

async function acceptFriendRequest(requestId) {
  try {
    await API.put(`/friendships/${requestId}/accept`);
    await loadFriendships();
    toast.add({
      severity: "success",
      message: t("profile.friend_request_accepted"),
      life: 3000,
    });
  } catch {
    toast.add({
      severity: "error",
      message: t("general.generic_error"),
      life: 3000,
    });
  }
}

async function revokeFriendRequest(requestId) {
  try {
    await API.delete(`/friendships/${requestId}`);
    outgoingRequests.value = outgoingRequests.value.filter(
      (request) => request.id !== requestId,
    );
    toast.add({
      severity: "success",
      message: t("profile.friend_request_revoked"),
      life: 3000,
    });
  } catch {
    toast.add({
      severity: "error",
      message: t("general.generic_error"),
      life: 3000,
    });
  }
}

async function removeFriend(friendshipId) {
  try {
    await API.delete(`/friendships/${friendshipId}`);
    friends.value = friends.value.filter(
      (friend) => friend.id !== friendshipId,
    );
    toast.add({
      severity: "success",
      message: t("profile.friend_removed"),
      life: 3000,
    });
  } catch {
    toast.add({
      severity: "error",
      message: t("general.generic_error"),
      life: 3000,
    });
  }
}

onMounted(loadFriendships);
</script>

<template>
  <div class="profile-view">
    <Header />
    <Form>
      <div class="profile-view-content">
        <ILImageUploader
          class="avatar-image-filter"
          :imageSrc="avatarUrl"
          :loading="avatarLoading"
          @file-selected="(file) => updateProfilePicture(file)"
          @file-removed="removeProfilePicture()"
        />
      </div>
      <div class="language-select-container">
        <ILSelect
          v-if="languages"
          v-model="selectedLanguage"
          :options="languages"
          :name="'language'"
          :label="t('profile.language')"
          optionLabel="label"
          @change="(event) => updateLanguage(event)"
        />
      </div>
      <section class="theme-section">
        <ILSelectButton
          v-model="theme"
          :aria-label="t('profile.theme')"
          :options="[
            { value: 'dark', label: t('profile.theme_dark') },
            { value: 'light', label: t('profile.theme_light') },
          ]"
          optionLabel="label"
          optionValue="value"
          @update:model-value="updateTheme"
        />
      </section>
    </Form>

    <section class="friends-section">
      <div class="friends-section-header">
        <h2>{{ t("profile.friends") }}</h2>
        <ILIconButton
          icon="pi-user-plus"
          variant="square"
          :aria-label="t('profile.add_friend')"
          @click="addFriendDrawer = true"
        />
      </div>

      <div v-if="incomingRequests.length" class="friend-list-container">
        <h3>{{ t("profile.friend_requests") }}</h3>
        <div class="friend-list">
          <div
            v-for="request in incomingRequests"
            :key="request.id"
            class="friend-row"
          >
            <ILAvatar
              :image="request.avatar_url"
              :username="request.username"
              class="friend-avatar"
            />
            <span>{{ request.username }}</span>
            <ILTextButton
              class="accept-button"
              :text="t('profile.accept_friend')"
              variant="fit-content"
              @click="acceptFriendRequest(request.id)"
            />
          </div>
        </div>
      </div>

      <div v-if="outgoingRequests.length" class="friend-list-container">
        <h3>{{ t("profile.pending_friend_requests") }}</h3>
        <div class="friend-list">
          <div
            v-for="request in outgoingRequests"
            :key="request.id"
            class="friend-row"
          >
            <ILAvatar
              :image="request.avatar_url"
              :username="request.username"
              class="friend-avatar"
            />
            <span>{{ request.username }}</span>
            <ILTextButton
              class="accept-button"
              :text="t('profile.revoke_friend_request')"
              variant="fit-content"
              color="red"
              @click="revokeFriendRequest(request.id)"
            />
          </div>
        </div>
      </div>

      <div class="friend-list-container">
        <h3>{{ t("profile.your_friends") }}</h3>
        <p v-if="!friendsLoading && !friends.length" class="empty-message">
          {{ t("profile.no_friends") }}
        </p>
        <div v-else class="friend-list">
          <div
            v-for="friend in friends"
            :key="friend.username"
            v-ripple
            class="friend-row friend-row-clickable"
            @click="
              router.push({
                name: 'friendHome',
                params: { username: friend.username },
              })
            "
          >
            <ILAvatar
              :image="friend.avatar_url"
              :username="friend.username"
              class="friend-avatar"
            />
            <span>{{ friend.username }}</span>
            <ILTextButton
              class="accept-button"
              :text="t('profile.remove_friend')"
              variant="fit-content"
              color="red"
              @click.stop="removeFriend(friend.id)"
            />
          </div>
        </div>
      </div>
    </section>

    <section class="account-section">
      <h2>{{ t("profile.account") }}</h2>
      <p class="security-note">
        {{ t("profile.account_security_note") }}
      </p>
      <Form
        :initialValues="accountForm"
        :resolver="accountResolver"
        class="account-form"
        @submit="updateAccount"
      >
        <ILTextInput
          name="username"
          :label="t('authentication.username')"
          autocomplete="username"
        />
        <ILTextInput
          name="email"
          :label="t('authentication.email')"
          type="email"
          autocomplete="email"
        />
        <ILTextInput
          name="current_password"
          :label="t('profile.current_password')"
          type="password"
          autocomplete="current-password"
        />
        <ILTextInput
          name="new_password"
          :label="t('profile.new_password')"
          type="password"
          autocomplete="new-password"
        />
        <ILTextInput
          name="confirm_new_password"
          :label="t('authentication.confirm_password')"
          type="password"
          autocomplete="new-password"
        />
        <ILTextButton
          :text="t('profile.save_account')"
          type="submit"
          :disabled="accountLoading"
        />
      </Form>
    </section>

    <ILDrawer v-model="addFriendDrawer" :title="t('profile.add_friend')">
      <template #body>
        <form class="add-friend-form" @submit.prevent="addFriend">
          <ILTextInput
            v-model="friendUsername"
            name="friend_username"
            :label="t('profile.friend_username')"
          />
          <ILTextButton
            :text="t('profile.add_friend')"
            type="submit"
            variant="fit-content"
            :disabled="requestLoading || !friendUsername.trim()"
          />
        </form>
      </template>
    </ILDrawer>
  </div>
</template>

<style scoped lang="scss">
.profile-view {
  .profile-view-content {
    margin: var(--gap-5) 0 var(--gap-4) 0;
  }

  .language-select-container {
    padding: var(--gap-2) var(--gap-3);
  }

  .theme-section {
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .account-section,
  .friends-section,
  .theme-section {
    margin: var(--gap-3) var(--gap-3);
    padding: var(--gap-3);
    border-radius: var(--border-radius-2);
    background-color: var(--color-2);
    display: flex;
    flex-direction: column;
    gap: var(--gap-3);
  }

  .account-form {
    display: flex;
    flex-direction: column;
    gap: var(--gap-3);
  }

  .security-note,
  .empty-message {
    margin: 0;
    color: var(--text-color-1-light);
  }

  .friends-section-header {
    display: flex;
    align-items: center;
    justify-content: space-between;

    h2 {
      margin: 0;
    }
  }

  .friend-list-container,
  .friend-list {
    display: flex;
    flex-direction: column;
    gap: var(--gap-2);
  }

  .friend-row {
    min-height: 48px;
    padding: var(--gap-2);
    border-radius: var(--border-radius-1);
    background-color: var(--color-0);
    display: flex;
    align-items: center;
    gap: var(--gap-2);

    &.friend-row-clickable {
      cursor: pointer;
    }
  }

  .friend-avatar {
    flex: 0 0 auto;
    background-color: var(--color-3);
    color: var(--text-color-1);
  }

  .accept-button {
    margin-left: auto;
  }
}

.add-friend-form {
  display: flex;
  align-items: center;
  gap: var(--gap-2);
}

@media (max-width: 480px) {
  .add-friend-form {
    align-items: stretch;
    flex-direction: column;
  }
}
</style>
