<script setup>
const props = defineProps({
  text: {
    type: String,
    required: true,
  },
  text2: {
    type: String,
    default: undefined,
  },
  icon: {
    type: String,
    default: undefined,
  },
  image: {
    type: String,
    default: undefined,
  },
});
</script>

<template>
  <div class="box-button-container">
    <p class="text">
      {{ props.text }}
    </p>
    <p v-if="props.text2" class="text">
      {{ props.text2 }}
    </p>
    <img v-if="props.image" :src="props.image" class="image" alt="book icon" />
    <i v-else-if="props.icon" :class="`pi ${props.icon}`"></i>
  </div>
</template>

<style scoped>
.box-button-container {
  background-color: var(--color-2);
  border-radius: var(--border-radius-1);
  padding: var(--gap-3);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--gap-2);
  width: 100%;
  cursor: pointer;

  .text {
    text-align: center;
    font-size: var(--font-size-4);
    margin: 0;
  }

  .image {
    height: 60px;
    object-fit: contain;
  }
}
</style>
