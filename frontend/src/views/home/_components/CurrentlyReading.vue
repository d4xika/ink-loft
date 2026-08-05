<script setup>
import { useI18n } from "vue-i18n";

const props = defineProps({
  coverImageUrl: {
    type: String,
    default: undefined,
  },
  title: {
    type: String,
    default: undefined,
  },
  author: {
    type: String,
    default: undefined,
  },
});

const { t } = useI18n();

const emit = defineEmits(["addQuote", "editRead", "finishRead", "showRead"]);
</script>

<template>
  <div class="currently-reading-container">
    <div class="content-container">
      <div class="left-container" @click="emit('showRead')">
        <ILReadCover
          :cover="props.coverImageUrl ? props.coverImageUrl : undefined"
        />
      </div>
      <div class="right-container">
        <div class="title-author-container" @click="emit('showRead')">
          <p class="title">
            {{ props.title }}
          </p>
          <p class="author">~ {{ props.author }}</p>
        </div>
        <div class="btn-container">
          <div class="quote-btn-container">
            <ILIconButton
              image="/images/drawings/quill.png"
              variant="full-width"
              @click="emit('addQuote')"
            />
          </div>
          <div class="edit-finish-btn-container">
            <ILTextButton
              :text="t('home.edit_read')"
              @click="emit('editRead')"
            />
            <ILTextButton
              :text="t('home.finish_read')"
              @click="emit('finishRead')"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.currently-reading-container {
  gap: var(--gap-3);

  .content-container {
    display: flex;
    gap: var(--gap-2);

    .left-container {
      display: flex;
      align-content: center;
      padding-right: var(--gap-2);
    }

    .right-container {
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding: var(--gap-2) 0;
      width: 100%;

      .title-author-container {
        display: flex;
        flex-direction: column;
        padding-bottom: var(--gap-2);

        .title {
          font-size: var(--font-size-4);
          margin: var(--gap-2) 0;
          max-width: 45dvw;
          overflow: hidden;
          text-overflow: ellipsis;
        }
        .author {
          font-size: var(--font-size-2);
          color: var(--text-color-1-light);
          margin: 0;
          max-width: 50dvw;
          overflow: hidden;
          text-overflow: ellipsis;
        }
      }

      .btn-container {
        display: flex;
        width: 100%;
        gap: var(--gap-2);

        .quote-btn-container {
          width: 55%;
        }

        .edit-finish-btn-container {
          display: flex;
          flex-direction: column;
          gap: var(--gap-2);
        }
      }
    }
  }
}
</style>
