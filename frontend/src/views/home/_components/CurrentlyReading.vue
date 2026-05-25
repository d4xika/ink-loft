<script setup>
import ILBookCover from "../../../components/ILBookCover.vue";

const props = defineProps({
  covers: {
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

const emit = defineEmits(["addQuote"]);
</script>

<template>
  <div class="currently-reading-container">
    <div class="content-container">
      <div class="left-container">
        <ILBookCover cover="/Test_Cover.jpg" />
      </div>
      <div class="right-container">
        <div class="title-author-container">
          <p class="title">
            {{ props.title }}
          </p>
          <p class="author">~ {{ props.author }}</p>
        </div>
        <div class="btn-container">
          <div class="quote-btn-container">
            <ILIconButton
              icon="pi-pen-to-square"
              variant="full-width"
              @click="emit('addQuote')"
            />
          </div>
          <div class="edit-finish-btn-container">
            <ILTextButton text="Edit read" />
            <ILTextButton text="Finish read" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.currently-reading-container {
  gap: var(--gap-3);
  padding: var(--gap-1);

  .content-container {
    display: flex;
    gap: var(--gap-2);

    .left-container {
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

        .title {
          font-size: var(--font-size-4);
          margin: var(--gap-2) 0;
        }
        .author {
          font-size: var(--font-size-2);
          color: var(--text-color-1-light);
          margin: 0;
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
