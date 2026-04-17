<script setup>
const props = defineProps({
  quote: {
    type: String,
    required: true,
  },
  source: {
    type: String,
    default: "Your Mom",
  },
});
</script>

<template>
  <div class="quotes-container">
    <h2 class="quote">"{{ props.quote }}"</h2>
    <h3 class="source">~ {{ props.source }}</h3>
  </div>
</template>

<style scoped>
.quotes-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100%;

  .quote {
    font-family: "EB Garamond", serif;
    font-style: italic;
    font-weight: normal;
    letter-spacing: 2px;
  }

  .source {
    text-align: right;
    width: 100%;
    margin-right: 30%;
    font-family: "Courier Prime", sans-serif;
    font-size: var(--font-size-2);
    font-weight: lighter;
    color: var(--text-color-1-light);
  }
}
</style>
