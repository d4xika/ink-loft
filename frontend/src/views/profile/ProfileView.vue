<script setup>
import { ref } from "vue";
import Header from "./_components/Header.vue";
import API from "../../helper/api.js";

const user = ref(JSON.parse(localStorage.getItem("user")));
const avatarUrl = ref(user.value?.avatar_url || null);
const avatarLoading = ref(false);

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function canLoadImage(url) {
  return new Promise((resolve) => {
    const image = new Image();
    image.onload = () => resolve(true);
    image.onerror = () => resolve(false);
    image.src = url;
  });
}

async function waitForAvatarUrl(url) {
  for (let attempt = 0; attempt < 20; attempt += 1) {
    const imageUrl = `${url}?t=${Date.now()}`;
    if (await canLoadImage(imageUrl)) {
      return imageUrl;
    }
    await sleep(500);
  }
  return `${url}?t=${Date.now()}`;
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

    user.value = response.data.user;
    localStorage.setItem("user", JSON.stringify(response.data.user));
    avatarUrl.value = await waitForAvatarUrl(response.data.user?.avatar_url);
    // TODO: add toast
  } catch (error) {
    // TODO: add toast
    console.error(error);
  } finally {
    avatarLoading.value = false;
  }
}
async function removeProfilePicture() {
  const formData = new FormData();

  formData.append("delete_avatar", "true");
  avatarLoading.value = true;

  API.put("/users/update_profile", formData).then((response) => {
    user.value = response.data.user;
    avatarUrl.value = response.data.user?.avatar_url || null;
    localStorage.setItem("user", JSON.stringify(response.data.user));
  }).finally(() => {
    avatarLoading.value = false;
  });
}
</script>

<template>
  <div>
    <Header />
    <div class="profile-view-content">
      <ILImageUploader
        :image-src="avatarUrl"
        :loading="avatarLoading"
        @file-selected="(file) => updateProfilePicture(file)"
        @file-removed="removeProfilePicture()"
      />
    </div>
  </div>
</template>

<style scoped>
.profile-view-content {
  margin-top: var(--gap-5);
}
</style>
