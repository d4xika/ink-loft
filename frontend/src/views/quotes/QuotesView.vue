<script setup>
import Header from "./_components/Header.vue";
import ILAddItem from "../../components/ILAddItem.vue";
import ILQuotes from "../../components/quote/ILQuotes.vue";
import ILQuoteSmall from "../../components/quote/ILQuoteSmall.vue";
</script>

<template>
  <div>
    <Header />
    <div class="quotes-view">
      <ILQuotes
        quote="hey"
        source="I killed your man, Katja Daxberger"
        editEnabled
        refreshEnabled
      />

      <ILDivider />
      <div class="more-quotes">
        <ILAddItem text="Add Quote" />
        <ILQuoteSmall
          quote="Do you want to build a snowman?"
          source="I killed your man, Katja Daxberger"
        />
      </div>
    </div>
  </div>
</template>

<style scoped>
.quotes-view {
  display: flex;
  flex-direction: column;
  padding: var(--gap-3);
  gap: var(--gap-4);

  .more-quotes {
    display: flex;
    flex-direction: column;
    gap: var(--gap-3);
  }
}
</style>
