<script setup>
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { useToast } from "primevue/usetoast";
import { computed, ref } from "vue";
import { useI18n } from "vue-i18n";
import { useRoute } from "vue-router";
import { z } from "zod";
import Header from "./_components/Header.vue";
import API from "@/helper/api.js";

const { t } = useI18n();
const toast = useToast();
const route = useRoute();
const currentUserId = JSON.parse(localStorage.getItem("user"))?.id;
const friendUsername = route.params.username || null;
const readonly = Boolean(friendUsername);
const addQuoteDrawer = ref(false);
const editQuoteDrawer = ref(false);
const quotes = ref({ loading: true });
const friendsByUserId = ref({});
const dailyQuote = ref(null);
const dailyQuoteSource = computed(
  () =>
    `${dailyQuote.value?.read?.title || "Your Mom"}${
      dailyQuote.value?.read?.author ? `, ${dailyQuote.value.read.author}` : ""
    }`,
);
const canEditDailyQuote = computed(
  () =>
    !readonly &&
    Boolean(dailyQuote.value?.content) &&
    dailyQuote.value?.user_id === currentUserId,
);
const addInitialValues = ref({});
const newQuoteInitialValues = { private: false };

const resolver = zodResolver(
  z.object({
    content: z.string().min(1, "Quote is required."),
    read: z.any().refine((val) => val && val.id, "Read is required."),
    private: z.boolean().default(false),
  }),
);

function setFriends(friends) {
  friendsByUserId.value = Object.fromEntries(
    friends.map((friend) => [friend.user_id, friend]),
  );
}

function quoteAttributes(values) {
  return {
    read_id: values.read.id,
    content: values.content,
    private: values.private,
  };
}

function showError(message = t("general.generic_error")) {
  toast.add({ severity: "error", message, life: 3000 });
}

function saveQuote(event) {
  if (!event.valid) {
    return;
  }

  API.post("quotes", {
    quote: quoteAttributes(event.values),
  }).then(
    () => {
      addQuoteDrawer.value = false;
      loadQuotes();
      toast.add({
        severity: "success",
        message: t("quotes.save_success"),
        life: 3000,
      });
    },
    () => showError(),
  );
}

function loadQuotes() {
  API.get("quotes", {
    params: { username: friendUsername || undefined },
  }).then(
    (response) => {
      quotes.value = response.data;
    },
    () => showError(t("quotes.load_error")),
  );
}

function loadDailyQuote(refresh = false) {
  const params = {
    username: friendUsername || undefined,
    ...(refresh && { refresh: true }),
  };

  API.get("quotes/daily_quote", { params }).then(
    (response) => {
      dailyQuote.value = response.data;
    },
    () => refresh && showError(),
  );
}

function reloadQuoteLibrary() {
  loadQuotes();
  loadDailyQuote();
}

function deleteQuote(quote) {
  API.delete(`quotes/${quote.id}`).then(
    () => {
      loadQuotes();
      toast.add({
        severity: "success",
        message: t("quotes.delete_success"),
        life: 3000,
      });
    },
    () => showError(),
  );
}

function openEditQuote(quote) {
  addInitialValues.value = {
    id: quote.id,
    read: quote.read,
    content: quote.content,
    private: quote.private,
  };

  editQuoteDrawer.value = true;
}

function editQuote(event) {
  if (!event.valid) {
    return;
  }

  API.put(`quotes/${addInitialValues.value.id}`, {
    quote: quoteAttributes(event.values),
  }).then(
    () => {
      editQuoteDrawer.value = false;
      reloadQuoteLibrary();
      toast.add({
        severity: "success",
        message: t("quotes.save_success"),
        life: 3000,
      });
    },
    () => showError(),
  );
}

loadQuotes();
loadDailyQuote();
</script>

<template>
  <div class="quotes-view-container">
    <Header
      :friendUsername="friendUsername"
      @friends-loaded="setFriends"
      @reload-quotes="reloadQuoteLibrary"
    />
    <div class="quotes-view">
      <ILQuotes
        :quote="dailyQuote?.content"
        :source="dailyQuoteSource"
        :editEnabled="canEditDailyQuote"
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

        <template v-if="quotes.loading">
          <div v-for="index in 3" :key="index">
            <Skeleton height="80px" />
          </div>
        </template>

        <template v-else>
          <ILQuoteSmall
            v-for="quote in quotes"
            :key="quote.id"
            :quote="quote.content"
            :source="`${quote.read.title}, ${quote.read.author}`"
            :readonly="readonly || quote.user_id !== currentUserId"
            :avatarUrl="friendsByUserId[quote.user_id]?.avatar_url"
            :username="friendsByUserId[quote.user_id]?.username"
            @delete="deleteQuote(quote)"
            @edit="openEditQuote(quote)"
          />
        </template>
      </div>
    </div>
    <ILDrawer
      v-if="!readonly"
      v-model="addQuoteDrawer"
      :title="t('quotes.add')"
    >
      <template #body>
        <Form
          :initialValues="newQuoteInitialValues"
          :resolver="resolver"
          class="flex flex-col gap-2"
          @submit="saveQuote"
        >
          <ILAutoComplete
            name="read"
            optionLabel="title"
            url="reads/autocomplete"
          />
          <ILTextArea name="content" :label="t('quotes.quote')" />
          <ILToggleSwitch :label="t('quotes.private_quote')" name="private" />
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
          class="flex flex-col gap-2"
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
          <ILToggleSwitch
            v-model="addInitialValues.private"
            :label="t('quotes.private_quote')"
            name="private"
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
