<script setup>
import { useI18n } from "vue-i18n";
import { useRouter } from "vue-router";

const props = defineProps({
  friendUsername: {
    type: String,
    default: null,
  },
});

const router = useRouter();
const { t } = useI18n();
</script>

<template>
  <div class="header-container">
    <ILIconButton
      icon="pi-chevron-left"
      variant="square"
      @click="
        router.push(
          props.friendUsername
            ? {
                name: 'friendHome',
                params: { username: props.friendUsername },
              }
            : { name: 'home' },
        )
      "
    />
    <h1 v-if="props.friendUsername">
      {{ t("quotes.quotes_of", { username: props.friendUsername }) }}
    </h1>
  </div>
</template>

<style scoped>
.header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--gap-3);
}
</style>
