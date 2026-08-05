<script setup>
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import { z } from "zod";
import Header from "./_components/Header.vue";
import API from "@/helper/api.js";
import { useToast } from "primevue/usetoast";

const { t } = useI18n();
const toast = useToast();
const addQuoteDrawer = ref(false);
const editQuoteDrawer = ref(false);
const quotes = ref([]);
const dailyQuote = ref(null);
const addInitialValues = ref({});

const resolver = zodResolver(
  z.object({
    content: z.string().min(1, "Quote is required."),
    read: z.any().refine((val) => val && val.id, "Read is required."),
  }),
);

function saveQuote(event) {
  if (!event.valid) {
    return;
  }

  API.post("quotes", {
    quote: {
      read_id: event.values.read.id,
      content: event.values.content,
    },
  }).then(
    (response) => {
      addQuoteDrawer.value = false;
      loadQuotes();
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

function loadQuotes() {
  API.get("quotes").then(
    (response) => {
      quotes.value = response.data;
    },
    (error) => {
      toast.add({
        severity: "error",
        message: t("quotes.load_error"),
        life: 3000,
      });
    },
  );
}

function loadDailyQuote(refresh = false) {
  let params = {};
  if (refresh) {
    params = {
      refresh: true,
    };
  }
  API.get("quotes/daily_quote", { params: params }).then(
    (response) => {
      dailyQuote.value = response.data;
    },
    (error) => {
      if (refresh) {
        toast.add({
          severity: "error",
          message: t("general.generic_error"),
          life: 3000,
        });
      }
    },
  );
}

function deleteQuote(quote) {
  API.delete(`quotes/${quote.id}`).then(
    (response) => {
      loadQuotes();
      toast.add({
        severity: "success",
        message: t("quotes.delete_success"),
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

function openEditQuote(quote) {
  addInitialValues.value = {
    id: quote.id,
    read: quote.read,
    content: quote.content,
  };

  editQuoteDrawer.value = true;
}

function editQuote(event) {
  if (!event.valid) {
    return;
  }

  API.put(`quotes/${addInitialValues.value.id}`, {
    quote: {
      read_id: event.values.read.id,
      content: event.values.content,
    },
  }).then(
    (response) => {
      editQuoteDrawer.value = false;
      loadQuotes();
      loadDailyQuote();
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

loadQuotes();
loadDailyQuote();
</script>

<template>
  <div>
    <Header />
    <div class="quotes-view">
      <ILQuotes
        :quote="dailyQuote?.content"
        :source="`${dailyQuote?.read?.title || 'Ink Loft'}${dailyQuote?.read?.author ? `, ${dailyQuote?.read?.author}` : ''}`"
        :editEnabled="!!dailyQuote?.content"
        :refreshEnabled="!!dailyQuote?.content"
        @edit="openEditQuote(dailyQuote)"
        @refresh="loadDailyQuote(true)"
      />

      <ILDivider />
      <div class="more-quotes">
        <ILAddItem :text="t('quotes.add')" @click="addQuoteDrawer = true" />
        <div v-for="quote in quotes" :key="quote.id">
          <ILQuoteSmall
            :quote="quote.content"
            :source="`${quote.read.title}, ${quote.read.author}`"
            @delete="deleteQuote(quote)"
            @edit="openEditQuote(quote)"
          />
        </div>
      </div>
    </div>
    <ILDrawer v-model="addQuoteDrawer" :title="t('quotes.add')">
      <template #body>
        <Form :resolver="resolver" class="form-container" @submit="saveQuote">
          <ILAutoComplete
            name="read"
            optionLabel="title"
            url="reads/autocomplete"
          />
          <ILTextArea name="content" :label="t('quotes.quote')" />
          <ILTextButton :text="t('quotes.save')" type="submit" />
        </Form>
      </template>
    </ILDrawer>
    <ILDrawer v-model="editQuoteDrawer" :title="t('quotes.edit')">
      <template #body>
        <Form
          :initialValues="addInitialValues"
          :resolver="resolver"
          class="form-container"
          @submit="editQuote"
        >
          <ILAutoComplete
            v-model="addInitialValues.read"
            name="read"
            optionLabel="title"
            url="reads/autocomplete"
          />
          <ILTextArea
            v-model="addInitialValues.content"
            name="content"
            :label="t('quotes.quote')"
          />
          <ILTextButton :text="t('quotes.save')" type="submit" />
        </Form>
      </template>
    </ILDrawer>
  </div>
</template>

<style scoped>
.quotes-view {
  display: flex;
  flex-direction: column;
  padding: var(--gap-3);
  gap: var(--gap-4);

  .more-quotes {
    display: flex;
    flex-direction: column;
    gap: var(--gap-3);
  }
}

.form-container {
  display: flex;
  flex-direction: column;
  gap: var(--gap-3);
}
</style>
