<script setup>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import { useRoute } from "vue-router";
import Header from "./Header.vue";
import API from "@/helper/api.js";
import { READING_STATUSES } from "@/helper/constants.js";
import router from "@/router/router.js";
import { useToast } from "primevue/usetoast";

const { t, n } = useI18n();
const route = useRoute();
const toast = useToast();

const read = ref({});
const isLoaded = ref(false);

function getReadData() {
  API.get(`reads/${route.params.id}`).then(
    (response) => {
      read.value = response.data;
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
          <ILReadCover :cover="read.cover_medium_url ?? undefined" />
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
          <ILTag
            :image="
              read.reading_status === 'want_to_read'
                ? '/images/drawings/read-list.png'
                : read.reading_status === 'have_read'
                  ? '/images/drawings/have-read.png'
                  : read.reading_status === 'dropped'
                    ? '/images/drawings/gravestone.png'
                    : '/images/drawings/curr-reading.png'
            "
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
              :text="n(read.chapters, 'decimal')"
              color="brown-1"
            />
            <ILTag
              v-if="read.pages"
              icon="pi-file"
              :text="n(read.pages, 'decimal')"
              color="brown-2"
            />
            <ILTag
              v-if="read.words"
              icon="pi-language"
              :text="n(read.words, 'decimal')"
              color="brown-3"
            />
            <ILTag
              v-if="read.platform"
              icon="pi-bookmark-fill"
              :text="read.platform"
              color="brown-4"
            />
          </div>

          <div
            class="bottom-container"
            v-if="read.pairing || read.notes || read.link"
          >
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

          <div class="quotes-area" v-if="read.quotes.length > 0">
            <ILDivider />

            <div class="quotes-container">
              <h1>{{ t("quotes.quotes") }}</h1>

              <div
                v-for="(quote, index) in read.quotes"
                :key="quote.id"
                class="quote"
              >
                {{ quote.content }}
                <ILDivider v-if="index !== read.quotes.length - 1" />
              </div>
            </div>
          </div>

          <div v-else class="bottom-spacing"></div>
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
        word-break: break-word;
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

        .quotes-area {
          display: flex;
          flex-direction: column;
          margin-top: var(--gap-3);
          gap: calc(var(--gap-3) + var(--gap-2));

          .quotes-container {
            display: flex;
            flex-direction: column;
            background-color: var(--color-2);
            border-radius: var(--border-radius-2);
            padding: calc(var(--gap-3) + var(--gap-1));
            gap: var(--gap-3);

            h1 {
              margin-bottom: var(--gap-1);
            }

            .quote {
              display: flex;
              flex-direction: column;
              gap: var(--gap-3);
              font-style: italic;
              color: var(--text-color-1-light);
            }
          }
        }

        .bottom-spacing {
          height: var(--gap-2);
        }
      }
    }
  }
}
</style>
