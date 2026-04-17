<script setup>
import Header from "./_components/Header.vue";
import Quotes from "./_components/Quotes.vue";
import CurrentlyReading from "./_components/CurrentlyReading.vue";
import ILBoxButton from "../../components/ILBoxButton.vue";
</script>

<template>
  <div class="home-view-container">
    <Header />
    <div class="content-container">
      <div class="quotes-container">
        <Quotes quote="You are not alone." />
      </div>
      <ILDivider />
      <CurrentlyReading title="Lunch baby" author="Me" />
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
