<script setup>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import { useRoute } from "vue-router";
import Header from "./Header.vue";
import ILTag from "../../components/primevue/ILTag.vue";
import API from "../../helper/api.js";
import { READING_STATUSES } from "../../helper/constants.js";
import router from "../../router/router.js";

const { t } = useI18n();
const route = useRoute();

const read = ref({});
const isLoaded = ref(false);

function getReadData() {
  API.get(`books/${route.params.id}`).then((response) => {
    read.value = response.data;
    isLoaded.value = true;
  });
}

getReadData();
</script>

<template>
  <div class="read-show-view">
    <Header
      editButtonEnabled
      @edit="router.push({ name: 'editRead', params: { id: read.id } })"
    />
    <div class="main-container" v-if="isLoaded">
      <div class="top-container">
        <div class="cover-container">
          <ILBookCover :cover="$route.params.cover" />
        </div>
        <div class="below-cover-container">
          <ILRating v-model="read.rating" />
          <ILTag
            :icon="read.recommended ? 'pi-check' : 'pi-times'"
            :color="read.recommended ? 'green' : 'red'"
            :text="
              read.recommended
                ? t('read.recommended')
                : t('read.not_recommended')
            "
          />
        </div>
      </div>
      <div class="content-container">
        <h1 class="title">{{ read.title }}</h1>
        <p class="text">{{ read.author }}</p>

        <div class="detail-content-container">
          <!-- TODO: add icons-->
          <ILTag
            icon="pi-book"
            :text="
              READING_STATUSES.find(
                (status) => status.id === read.reading_status,
              ).label
            "
            size="big"
          />

          <div v-if="read.start_date || read.end_date" class="date-container">
            <p v-if="read.start_date" class="date">{{ read.start_date }}</p>
            <div class="date-separator"></div>
            <p v-if="read.end_date" class="date">{{ read.end_date }}</p>
          </div>

          <div class="tags-container">
            <ILTag
              v-if="read.chapters"
              icon="pi-bookmark"
              :text="read.chapters"
              color="brown-1"
            />
            <ILTag
              v-if="read.pages"
              icon="pi-file"
              :text="read.pages"
              color="brown-2"
            />
            <ILTag
              v-if="read.words"
              icon="pi-language"
              :text="read.words"
              color="brown-3"
            />
            <ILTag
              v-if="read.platform"
              icon="pi-bookmark-fill"
              :text="read.platform"
              color="brown-4"
            />
          </div>

          <div class="bottom-container">
            <p v-if="read.pairing">{{ read.pairing }}</p>

            <div class="notes-container" v-if="read.notes">
              <p>{{ read.notes }}</p>
            </div>

            <ILTag
              v-if="read.link"
              :text="read.link"
              icon="pi-link"
              color="white"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.read-show-view {
  display: flex;
  flex-direction: column;
  gap: var(--gap-3);
  padding: var(--gap-3);

  .main-container {
    display: flex;
    flex-direction: column;
    gap: var(--gap-4);
    align-items: center;

    .top-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: var(--gap-3);
      width: 85%;

      .cover-container {
        display: flex;
        justify-content: center;
        padding: var(--gap-3);
        background-color: var(--color-2);
        border-radius: var(--border-radius-2);
        width: 100%;
      }

      .below-cover-container {
        display: flex;
        justify-content: space-between;
        width: 100%;
      }
    }

    .content-container {
      width: 85%;

      .title {
        font-family: "Petit Formal Script", serif !important;
      }

      .text {
        margin: 0;
        color: var(--text-color-1-light);
      }

      .detail-content-container {
        display: flex;
        flex-direction: column;
        margin-top: var(--gap-3);
        gap: var(--gap-2);

        .date-container {
          display: flex;
          gap: var(--gap-1);
          align-items: center;

          .date {
            text-wrap: nowrap;
          }

          .date-separator {
            border: dashed 1px var(--text-color-1-light);
            width: 100%;
            margin: 0 var(--gap-1);
          }
        }

        .tags-container {
          display: flex;
          flex-wrap: wrap;
          gap: var(--gap-2);
        }

        .bottom-container {
          display: flex;
          flex-direction: column;
          gap: var(--gap-3);
          padding-top: var(--gap-3);

          .notes-container {
            border: solid 1px var(--text-color-1-light);
            padding: var(--gap-3);
            border-radius: var(--border-radius-2);
          }

          p {
            margin: 0;
          }
        }
      }
    }
  }
}
</style>
