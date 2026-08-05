<script setup>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import Header from "./_components/Header.vue";
import API from "@/helper/api.js";
import { languages } from "@/helper/i18n/i18n.js";
import { useToast } from "primevue/usetoast";

const { locale } = useI18n();
const { t } = useI18n();
const toast = useToast();
const user = ref(JSON.parse(localStorage.getItem("user")));
const avatarUrl = ref(user.value?.avatar_url.medium || null);
const avatarLoading = ref(false);

const selectedLanguage = ref(
  languages.find((language) => language.value === user.value?.language) ||
    languages[0],
);

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
    avatarUrl.value = response.data.user?.avatar_url.medium || null;
    toast.add({
      severity: "success",
      message: t("profile.avatar_update_success"),
      life: 3000,
    });
  } catch (error) {
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
      user.value = response.data.user;
      avatarUrl.value = response.data.user?.avatar_url.medium || null;
      localStorage.setItem("user", JSON.stringify(response.data.user));
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
function updateLanguage(event) {
  if (!event?.value?.value) return;
  locale.value = event.value.value;
  API.put("/users/update_profile", { language: event.value.value }).then(
    (response) => {
      user.value = response.data.user;
      localStorage.setItem("user", JSON.stringify(response.data.user));
      toast.add({
        severity: "success",
        message: t("profile.update_success"),
        life: 3000,
      });
    },
    (error) => {
      toast.add({
        severity: "error",
        message: t("profile.update_error"),
        life: 3000,
      });
    },
  );
}
</script>

<template>
  <div>
    <Header />
    <Form>
      <div class="profile-view-content">
        <ILImageUploader
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
    </Form>
  </div>
</template>

<style scoped>
.profile-view-content {
  margin: var(--gap-5) 0 var(--gap-4) 0;
}

.language-select-container {
  padding: var(--gap-3);
}
</style>
