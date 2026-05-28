<script setup>
const props = defineProps({
  title: {
    type: String,
    required: true,
  },
  textContent: {
    type: String,
    required: true,
  },
  confirmText: {
    type: String,
    default: "Confirm",
  },
  type: {
    type: String,
    default: "positive",
    validator: (value) => ["positive", "negative"].includes(value),
  },
});

const model = defineModel({ type: Boolean, default: false });
const emit = defineEmits(["confirm"]);
</script>

<template>
  <ILDrawer :title="props.title" v-model="model">
    <template #body>
      <p>{{ props.textContent }}</p>
      <div
        class="buttons-container"
        :class="{ 'is-negative': props.type === 'negative' }"
      >
        <ILTextButton
          text="Cancel"
          @click="model = false"
          color="transparent"
        />
        <ILTextButton
          :text="props.confirmText"
          :color="props.type === 'positive' ? 'primary' : 'red'"
          @click="$emit('confirm')"
        />
      </div>
    </template>
  </ILDrawer>
</template>

<style scoped>
.buttons-container {
  display: flex;
  gap: var(--gap-3);

  &.is-negative {
    flex-direction: row-reverse;
  }
}
</style>
