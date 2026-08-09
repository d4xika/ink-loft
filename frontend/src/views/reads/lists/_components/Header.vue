<script setup>
import { useRouter } from "vue-router";

const props = defineProps({
  title: {
    type: String,
    required: true,
  },
  image: {
    type: String,
    default: undefined,
  },
  readingStatus: {
    type: String,
    default: undefined,
    validator: (value) =>
      ["want_to_read", "have_read", "dropped"].includes(value),
  },
});

const router = useRouter();
</script>

<template>
  <div class="header-container">
    <ILIconButton
      icon="pi-chevron-left"
      variant="square"
      @click="router.push({ name: 'home' })"
    />

    <div class="content-image-container">
      <img
        v-if="props.image"
        :src="props.image"
        class="header-image"
        alt="header icon"
      />

      <div class="title-plus-container">
        <h1>{{ props.title }}</h1>
        <ILIconButton
          icon="pi-plus"
          variant="square"
          color="brown"
          @click="
            router.push({
              name: 'newRead',
              query: { status: props.readingStatus },
            })
          "
        />
      </div>
    </div>

    <ILDivider />
  </div>
</template>

<style scoped>
.header-container {
  display: flex;
  flex-direction: column;
  padding: var(--gap-3);
  gap: var(--gap-4);

  .content-image-container {
    display: flex;
    align-items: flex-end;
    gap: var(--gap-3);

    .title-plus-container {
      display: flex;
      flex-direction: column;
      gap: var(--gap-2);
      align-items: flex-start;
      flex: 1;
    }

    .header-image {
      height: 100px;
      object-fit: contain;
    }
  }

  h1 {
    margin: 0;
  }
}
</style>
