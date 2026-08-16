<script setup>
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import { useRoute } from "vue-router";
import { z } from "zod";
import Header from "./_components/Header.vue";
import API from "@/helper/api.js";
import { useToast } from "primevue/usetoast";

const { t } = useI18n();
const toast = useToast();
const route = useRoute();
const friendUsername = route.params.username || null;
const readonly = Boolean(friendUsername);
const addQuoteDrawer = ref(false);
const editQuoteDrawer = ref(false);
const quotes = ref({ loading: true });
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
  API.get("quotes", {
    params: { username: friendUsername || undefined },
  }).then(
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
  let params = { username: friendUsername || undefined };
  if (refresh) {
    params = {
      refresh: true,
      username: friendUsername || undefined,
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
  <div class="quotes-view-container">
    <Header :friendUsername="friendUsername" />
    <div class="quotes-view">
      <ILQuotes
        :quote="dailyQuote?.content"
        :source="`${dailyQuote?.read?.title || 'Ink Loft'}${dailyQuote?.read?.author ? `, ${dailyQuote?.read?.author}` : ''}`"
        :editEnabled="!readonly && !!dailyQuote?.content"
        :refreshEnabled="!readonly && !!dailyQuote?.content"
        @edit="openEditQuote(dailyQuote)"
        @refresh="loadDailyQuote(true)"
      />

      <ILDivider />
      <div class="more-quotes">
        <ILAddItem
          v-if="!readonly"
          :text="t('quotes.add')"
          @click="addQuoteDrawer = true"
        />

        <div v-if="quotes.loading" v-for="index in 3" :key="index">
          <Skeleton height="80px" />
        </div>

        <div v-else v-for="quote in quotes" :key="quote.id">
          <ILQuoteSmall
            :quote="quote.content"
            :source="`${quote.read.title}, ${quote.read.author}`"
            :readonly="readonly"
            @delete="deleteQuote(quote)"
            @edit="openEditQuote(quote)"
          />
        </div>
      </div>
    </div>
    <ILDrawer
      v-if="!readonly"
      v-model="addQuoteDrawer"
      :title="t('quotes.add')"
    >
      <template #body>
        <Form
          :resolver="resolver"
          @submit="saveQuote"
          class="flex flex-col gap-2"
        >
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
    <ILDrawer
      v-if="!readonly"
      v-model="editQuoteDrawer"
      :title="t('quotes.edit')"
    >
      <template #body>
        <Form
          :initialValues="addInitialValues"
          :resolver="resolver"
          @submit="editQuote"
          class="flex flex-col gap-2"
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
.quotes-view-container {
  padding-bottom: var(--gap-2);

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
}
</style>
