<script setup>
import Header from "./_components/Header.vue";
import API from "../../helper/api.js";

function updateProfilePicture(file) {
  const formData = new FormData();

  formData.append("avatar", file);

  API.put("/users/update_profile", formData, {
    headers: {
      "Content-Type": "multipart/form-data",
    },
  }).then(
    (response) => {
      localStorage.setItem("user", JSON.stringify(response.data.user));
      // TODO: add toasti
    },
    (error) => {
      // TODO: add toasti
    },
  );
}

function removeProfilePicture() {
  const formData = new FormData();

  formData.append("delete_avatar", "true");

  API.put("/users/update_profile", formData).then((response) => {
    localStorage.setItem("user", JSON.stringify(response.data.user));
  });
}
</script>

<template>
  <div>
    <Header />
    <div class="profile-view-content">
      <ILImageUploader
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
