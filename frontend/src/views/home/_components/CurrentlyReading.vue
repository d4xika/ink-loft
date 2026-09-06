<script setup>
import { computed } from "vue";
import { useI18n } from "vue-i18n";

const props = defineProps({
  read: {
    type: Object,
    required: true,
  },
});

const { t } = useI18n();

const emit = defineEmits(["addQuote", "trackRead", "finishRead", "showRead"]);

const progress = computed(() => {
  if (!props.read.progress_type || !props.read.current_progress) {
    return false;
  }

  if (props.read.progress_type === "percentage") {
    return props.read.current_progress;
  }

  const total =
    props.read.progress_type === "chapters"
      ? props.read.chapters
      : props.read.pages;

  return (props.read.current_progress / total) * 100;
});
</script>

<template>
  <div class="currently-reading-container">
    <div class="content-container">
      <div v-ripple class="left-container" @click="emit('showRead')">
        <ILReadCover
          :cover="
            props.read.cover_small_url ? props.read.cover_small_url : undefined
          "
        />
      </div>
      <div class="right-container">
        <div v-ripple class="title-author-container" @click="emit('showRead')">
          <p class="title">
            {{ props.read.title }}
          </p>
          <p class="author">~ {{ props.read.author }}</p>
        </div>
        <div>
          <ILProgressBar
            v-if="progress"
            class="tracking-progress-bar"
            :value="progress"
          />
        </div>
        <div class="btn-container">
          <div class="quote-btn-container">
            <ILIconButton
              image="/images/drawings/quill.png"
              @click="emit('addQuote')"
            />
          </div>
          <div class="track-finish-btn-container">
            <ILTextButton :text="t('home.track')" @click="emit('trackRead')" />
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

  :deep(.tracking-progress-bar .p-progressbar-value) {
    transition: width 700ms ease-in-out;
  }

  .content-container {
    display: flex;
    gap: var(--gap-2);

    .left-container {
      display: flex;
      flex-shrink: 0;
      align-content: center;
      padding-right: var(--gap-2);
      width: var(--read-cover-width);
    }

    .right-container {
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding-top: var(--gap-2);
      gap: var(--gap-2);
      width: 100%;

      .title-author-container {
        display: flex;
        flex-direction: column;

        .title {
          font-size: var(--font-size-4);
          margin: 0;
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

        .track-finish-btn-container {
          display: flex;
          flex-direction: column;
          gap: var(--gap-2);
          width: 100%;
        }
      }
    }
  }
}
</style>
