<script setup>
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import { z } from "zod";
import Header from "./Header.vue";
import { READING_STATUSES } from "@/helper/constants.js";

const { t } = useI18n();

const props = defineProps({
  initialValues: {
    type: Object,
    default: () => ({}),
  },
});
const emit = defineEmits(["save"]);

const resolver = zodResolver(
  z.object({
    title: z.string().min(1, "Title is required."),
    author: z.string().nullable(),
    platform: z.string().nullable(),
    pairing: z.string().nullable(),
    chapters: z.coerce.number().nullable(),
    words: z.coerce.number().nullable(),
    pages: z.coerce.number().nullable(),
    rating: z.number().nullable(),
    start_date: z.string().nullable().optional(),
    end_date: z.string().nullable().optional(),
    recommended: z.boolean().nullable(),
    reading_status: z.string().nullable(),
  }),
);

const coverImage = ref(null);
const coverRemoved = ref(false);

function onFileSelected(file) {
  coverImage.value = file;
  coverRemoved.value = false;
}

function onFileRemoved() {
  coverImage.value = null;
  coverRemoved.value = true;
}
</script>

<template>
  <Form
    :initialValues="props.initialValues"
    :resolver="resolver"
    @submit="(data) => emit('save', { ...data, coverImage, coverRemoved })"
  >
    <Header saveButtonEnabled />
    <div class="content-container">
      <div class="main-content-container">
        <div class="title-author-container">
          <img src="/divider_book.png" alt="divider" />
          <ILTextInput :label="t('read.title')" name="title" />
          <ILTextInput :label="t('read.author')" name="author" />
        </div>
        <div class="rating-section">
          <ILImageUploader
            variant="rectangle"
            :title="t('read.cover')"
            name="cover"
            :imageSrc="props.initialValues.cover_small_url"
            @file-selected="onFileSelected"
            @file-removed="onFileRemoved"
          />
          <ILRating name="rating" v-model="initialValues.rating" editEnabled />
        </div>
      </div>
      <ILSelect
        :options="READING_STATUSES"
        optionLabel="label"
        optionValue="id"
        :label="t('read.reading_status.reading_status')"
        name="reading_status"
      />
      <div class="side-by-side">
        <ILDatePicker
          :label="t('read.start_date')"
          name="start_date"
          v-model="initialValues.start_date"
        />
        <ILDatePicker
          :label="t('read.end_date')"
          name="end_date"
          v-model="initialValues.end_date"
        />
      </div>
      <ILToggleSwitch
        :label="t('read.would_recommend')"
        name="recommended"
        v-model="initialValues.recommended"
      />
      <!-- TODO: maybe change to combobox -->
      <ILTextInput :label="t('read.platform')" name="platform" />
      <ILNumberInput :label="t('read.chapters')" name="chapters" />
      <ILNumberInput :label="t('read.words')" name="words" />
      <ILNumberInput :label="t('read.pages')" name="pages" />
      <ILTextInput :label="t('read.pairing')" name="pairing" />
      <ILTextArea :label="t('read.notes')" name="notes" />
      <ILTextInput :label="t('read.link')" name="link" />
    </div>
  </Form>
</template>

<style scoped>
.content-container {
  display: flex;
  flex-direction: column;
  gap: var(--gap-3);

  .side-by-side {
    display: flex;
    gap: var(--gap-3);
  }

  .rating-section {
    display: flex;
    flex-direction: column;
    gap: var(--gap-3);
    padding-bottom: calc(var(--gap-1) + 2px);
  }

  .main-content-container {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: end;

    .title-author-container {
      display: flex;
      flex-direction: column;
      gap: var(--gap-3);
      width: 100%;
      padding-right: var(--gap-3);

      img {
        padding-left: var(--gap-3);
        padding-right: var(--gap-3);
        width: calc(100%);
      }
    }
  }
}
</style>
