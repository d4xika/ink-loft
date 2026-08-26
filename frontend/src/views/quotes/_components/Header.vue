<script setup>
import { useRouter } from "vue-router";

const props = defineProps({
  friendUsername: {
    type: String,
    default: null,
  },
});

const router = useRouter();
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
