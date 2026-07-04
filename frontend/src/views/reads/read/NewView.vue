<script setup>
import ReadForm from "./ReadForm.vue";
import API from "../../../helper/api.js";
import router from "../../../router/router.js";
import { useToast } from "primevue/usetoast";
import { useI18n } from "vue-i18n";

const { t } = useI18n();
const toast = useToast();

const initRead = {
  title: null,
  author: null,
  cover: null,
  platform: null,
  pairing: null,
  chapters: null,
  words: null,
  pages: null,
  rating: null,
  recommended: null,
};

function saveRead(data) {
  if (!data.valid) {
    toast.add({
      severity: "error",
      message: t("general.validation_error_detail"),
      life: 3000,
    });
    return;
  }

  const formData = new FormData();

  const book = {};
  Object.keys(data.states).forEach((state) => {
    book[`${state}`] = data.states[state].value;
  });

  formData.append("book", JSON.stringify(book));

  if (data.coverImage) {
    formData.append("cover", data.coverImage);
  }

  API.post("books", formData, {
    headers: {
      "Content-Type": "multipart/form-data",
    },
  }).then(
    (response) => {
      router.push({ name: "home" });
      toast.add({
        severity: "success",
        message: t("read.save_success"),
        life: 3000,
      });
    },
    (error) => {
      toast.add({
        severity: "error",
        message: t("general.generic_error"),
        life: 3000,
      });
    },
  );
}
</script>

<template>
  <div>
    <div class="read-new-view">
      <ReadForm :initialValues="initRead" @save="(read) => saveRead(read)" />
    </div>
  </div>
</template>

<style scoped>
.read-new-view {
  padding: var(--gap-3);
}
</style>
