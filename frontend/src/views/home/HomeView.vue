<script setup>
import { ref, onMounted } from "vue";
import Header from "./_components/Header.vue";
import Quotes from "./_components/Quotes.vue";
import CurrentlyReading from "./_components/CurrentlyReading.vue";
import ILBoxButton from "../../components/ILBoxButton.vue";
import { useRouter } from "vue-router";

const router = useRouter();
const swipeContainer = ref(null);

onMounted(() => {
  if (swipeContainer.value) {
    swipeContainer.value.scrollLeft = swipeContainer.value.scrollWidth;
  }
});
</script>

<template>
  <div class="home-view-container">
    <Header />
    <div class="content-container">
      <div class="quotes-container">
        <Quotes quote="You are not alone." />
      </div>
      <ILDivider />

      <div class="swipe-wrapper" ref="swipeContainer">
        <div class="swipe-actions">
          <ILBoxButton text="Add read" icon="pi-plus" />
          <ILBoxButton
            @click="router.push({ name: 'newBook' })"
            text="New read"
            icon="pi-plus"
          />
        </div>

        <div class="swipe-main">
          <CurrentlyReading title="Lunch baby" author="Me" />
        </div>
      </div>

      <ILDivider />
      <div class="box-container">
        <div class="box-buttons-container">
          <ILBoxButton text="Want to read" icon="pi-bookmark" />
          <ILBoxButton text="Have read" icon="pi-book" />
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.home-view-container {
  display: flex;
  flex-direction: column;
  padding: var(--gap-3);

  .content-container {
    display: flex;
    flex-direction: column;
    margin-top: var(--gap-4);
    gap: var(--gap-4);

    .quotes-container {
      background-color: var(--color-2);
      border-radius: var(--border-radius-1);
      padding: var(--gap-2);
    }

    .swipe-wrapper {
      display: flex;
      overflow-x: auto;
      scroll-snap-type: x mandatory;
      gap: var(--gap-3);

      scrollbar-width: none;
      &::-webkit-scrollbar {
        display: none;
      }

      .swipe-actions {
        display: flex;
        flex-direction: column;
        justify-content: center;
        margin-top: var(--gap-4);
        gap: var(--gap-2);
        flex-shrink: 0;
        scroll-snap-align: start;
      }

      .swipe-main {
        flex-shrink: 0;
        scroll-snap-align: end;
        width: calc(100% - 30px);
      }
    }

    .box-container {
      display: flex;
      flex-direction: column;

      .box-buttons-container {
        display: flex;
        justify-content: center;
        gap: var(--gap-3);
      }
    }
  }
}
</style>
