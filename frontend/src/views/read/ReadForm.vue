<script setup>
import { ref } from "vue";
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { z } from "zod";
import Header from "./Header.vue";
import ILSelect from "../../components/primevue/ILSelect.vue";
import ILTextInput from "../../components/primevue/ILTextInput.vue";
import ILImageUploader from "../../components/primevue/ILImageUploader.vue";
import ILRating from "../../components/primevue/ILRating.vue";
import ILDatePicker from "../../components/primevue/ILDatePicker.vue";
import ILToggleSwitch from "../../components/primevue/ILToggleSwitch.vue";
import ILNumberInput from "../../components/primevue/ILNumberInput.vue";
import ILTextArea from "../../components/primevue/ILTextArea.vue";
import { READING_STATUSES } from "@/helper/constants.js";

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
    <Header />
    <div class="content-container">
      <div class="main-content-container">
        <div class="title-author-container">
          <img src="/divider_book.png" alt="divider" />
          <ILTextInput label="Title" name="title" />
          <ILTextInput label="Author" name="author" />
        </div>
        <div class="rating-section">
          <ILImageUploader
            variant="rectangle"
            title="Cover"
            name="cover"
            :imageSrc="props.initialValues.cover_url"
            @file-selected="onFileSelected"
            @file-removed="onFileRemoved"
          />
          <ILRating name="rating" v-model="initialValues.rating" />
        </div>
      </div>
      <ILSelect
        :options="READING_STATUSES"
        optionLabel="label"
        optionValue="id"
        label="Reading Status"
        name="reading_status"
      />
      <div class="side-by-side">
        <ILDatePicker
          label="Start Date"
          name="start_date"
          v-model="initialValues.start_date"
        />
        <ILDatePicker
          label="End Date"
          name="end_date"
          v-model="initialValues.end_date"
        />
      </div>
      <ILToggleSwitch
        label="Would recommend:"
        name="recommended"
        v-model="initialValues.recommended"
      />
      <!-- TODO: maybe change to combobox -->
      <ILTextInput label="Platform" name="platform" />
      <ILNumberInput label="Chapters" name="chapters" />
      <ILNumberInput label="Words" name="words" />
      <ILNumberInput label="Pages" name="pages" />
      <ILTextInput label="Pairing" name="pairing" />
      <ILTextArea label="Notes" name="notes" />
      <ILTextInput label="Link" name="link" />
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
