<script setup>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import { useRoute } from "vue-router";
import ReadForm from "./ReadForm.vue";
import API from "@/helper/api.js";
import router from "@/router/router.js";
import { useToast } from "primevue/usetoast";

const { t } = useI18n();
const route = useRoute();
const toast = useToast();

const readInitValues = ref({});

const isLoaded = ref(false);

const deleteReadDrawer = ref(false);

function getReadData() {
  API.get(`reads/${route.params.id}`).then(
    (response) => {
      readInitValues.value = response.data;
      isLoaded.value = true;
    },
    (error) => {
      toast.add({
        severity: "error",
        message: t("read.load_error"),
        life: 3000,
      });
    },
  );
}

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

  const read = {};
  Object.keys(data.states).forEach((state) => {
    read[`${state}`] = data.states[state].value;
  });

  formData.append("read", JSON.stringify(read));

  if (data.coverImage) {
    formData.append("cover", data.coverImage);
  }

  if (data.coverRemoved) {
    formData.append("remove_cover", "true");
  }

  API.put(`reads/${route.params.id}`, formData, {
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

function openDeleteReadDrawer() {
  deleteReadDrawer.value = true;
}

function deleteRead() {
  API.delete(`reads/${route.params.id}`).then(
    (response) => {
      deleteReadDrawer.value = false;
      router.push({ name: "home" });
      toast.add({
        severity: "success",
        message: t("read.delete_success"),
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

getReadData();
</script>

<template>
  <div>
    <div class="read-edit-view">
      <ReadForm
        v-if="isLoaded"
        :initialValues="readInitValues"
        @save="(read) => saveRead(read)"
      />

      <div class="button-container" v-if="isLoaded">
        <ILTextButton
          :text="t('read.delete')"
          @click="openDeleteReadDrawer()"
          color="red"
        />
      </div>
    </div>

    <ILConfirmationDrawer
      v-model="deleteReadDrawer"
      :title="t('read.delete')"
      :confirmText="t('general.delete')"
      :textContent="t('read.delete_confirmation')"
      type="negative"
      @confirm="deleteRead()"
    />
  </div>
</template>

<style scoped>
.read-edit-view {
  display: flex;
  flex-direction: column;
  gap: var(--gap-3);
  padding: var(--gap-3);
}
</style>
