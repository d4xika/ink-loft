<script setup>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import { useRoute } from "vue-router";
import ReadForm from "./ReadForm.vue";
import API from "@/helper/api.js";
import router from "@/router/router.js";
import { useToast } from "primevue/usetoast";
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { z } from "zod";

const { t } = useI18n();
const route = useRoute();
const toast = useToast();

const readInitValues = ref({});

const isLoaded = ref(false);

const deleteReadDrawer = ref(false);
const quoteDrawer = ref(false);
const quoteDraft = ref({ content: "" });
const editingQuoteId = ref(null);

const quoteResolver = zodResolver(
  z.object({
    content: z.string().min(1, "Quote is required."),
  }),
);

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

function openQuoteDrawer(quote = null) {
  editingQuoteId.value = quote?.id ?? null;
  quoteDraft.value = { content: quote?.content ?? "" };
  quoteDrawer.value = true;
}

function saveQuote(event) {
  if (!event.valid) {
    return;
  }

  const request = editingQuoteId.value
    ? API.put(`quotes/${editingQuoteId.value}`, {
        quote: { content: event.values.content },
      })
    : API.post("quotes", {
        quote: {
          read_id: route.params.id,
          content: event.values.content,
        },
      });

  request.then(
    (response) => {
      const savedQuote = response.data;
      if (editingQuoteId.value) {
        const quote = readInitValues.value.quotes.find(
          (item) => item.id === editingQuoteId.value,
        );
        if (quote) quote.content = savedQuote.content;
      } else {
        readInitValues.value.quotes = [
          savedQuote,
          ...(readInitValues.value.quotes ?? []),
        ];
      }
      quoteDrawer.value = false;
      toast.add({
        severity: "success",
        message: t("quotes.save_success"),
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
  <div class="edit-view-container">
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

      <div v-if="isLoaded" class="quotes-editor">
        <ILDivider />
        <div class="quotes-header">
          <h2>{{ t("quotes.quotes") }}</h2>
        </div>
        <ILAddItem :text="t('quotes.add')" @click="openQuoteDrawer()" />

        <p v-if="!readInitValues.quotes?.length" class="empty-quotes">
          {{ t("quotes.no_quotes") }}
        </p>
        <div v-else class="quote-list">
          <div
            v-for="quote in readInitValues.quotes"
            :key="quote.id"
            class="quote-item"
          >
            <p class="font-fix">{{ quote.content }}</p>
            <i class="pi pi-pencil font-fix" @click="openQuoteDrawer(quote)" />
          </div>
        </div>
      </div>
    </div>

    <ILDrawer
      v-model="quoteDrawer"
      :title="editingQuoteId ? t('quotes.edit') : t('quotes.add')"
    >
      <template #body>
        <Form
          :initialValues="quoteDraft"
          :resolver="quoteResolver"
          @submit="saveQuote"
          class="flex flex-col gap-2"
        >
          <ILTextArea
            v-model="quoteDraft.content"
            name="content"
            :label="t('quotes.quote')"
          />
          <ILTextButton :text="t('quotes.save')" type="submit" />
        </Form>
      </template>
    </ILDrawer>

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
.edit-view-container {
  padding-bottom: var(--gap-2);

  .read-edit-view {
    display: flex;
    flex-direction: column;
    gap: var(--gap-3);
    padding: var(--gap-3);

    .quotes-editor {
      display: flex;
      flex-direction: column;
      gap: var(--gap-3);

      .quotes-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: var(--gap-3);

        h2 {
          margin: 0;
        }
      }

      .quote-list {
        display: flex;
        flex-direction: column;
        gap: var(--gap-2);
      }

      .quote-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: var(--gap-3);
        padding: var(--gap-3);
        border: 1px solid var(--color-2);
        border-radius: var(--border-radius-1);

        p {
          margin: 0;
          white-space: pre-wrap;
        }

        i {
          font-size: var(--font-size-2) !important;
        }
      }

      .empty-quotes {
        color: var(--text-color-1-light);
      }
    }
  }
}
</style>
