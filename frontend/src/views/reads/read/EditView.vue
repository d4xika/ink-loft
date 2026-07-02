<script setup>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import { useRoute } from "vue-router";
import ReadForm from "./ReadForm.vue";
import ILConfirmationDrawer from "@/components/drawer/ILConfirmationDrawer.vue";
import API from "@/helper/api.js";
import router from "@/router/router.js";

const { t } = useI18n();
const route = useRoute();

const readInitValues = ref({});

const isLoaded = ref(false);

const deleteReadDrawer = ref(false);

function getReadData() {
  API.get(`books/${route.params.id}`).then((response) => {
    readInitValues.value = response.data;
    isLoaded.value = true;
  });
}

function saveRead(data) {
  if (!data.valid) {
    // TODO: add toasti
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

  if (data.coverRemoved) {
    formData.append("remove_cover", "true");
  }

  API.put(`books/${route.params.id}`, formData, {
    headers: {
      "Content-Type": "multipart/form-data",
    },
  }).then((response) => {
    router.push({ name: "home" });
  });
}

function openDeleteReadDrawer() {
  deleteReadDrawer.value = true;
}

function deleteRead() {
  API.delete(`books/${route.params.id}`).then((response) => {
    deleteReadDrawer.value = false;
    router.push({ name: "home" });
  });
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
