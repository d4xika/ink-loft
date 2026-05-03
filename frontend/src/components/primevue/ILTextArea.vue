<script setup>
const props = defineProps({
  label: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  }
});

const model = defineModel({ type: String, default: "" })
</script>

<template>
  <FloatLabel variant="on">
    <Textarea
      v-model="model"
      :name="props.name"
      rows="5"
      cols="30"
      style="resize: none"
    />
    <label>{{ props.label }}</label>
  </FloatLabel>
</template>

<style scoped>
.p-floatlabel {
  width: 100% !important;
}

.p-textarea {
  width: 100% !important;
  background-color: var(--color-0);
  border: 1px solid var(--color-2);
  font-size: var(--font-size-3);
  padding-top: 11px !important;

  &:enabled:focus {
    border: 1px solid var(--text-color-1);
  }
}

label {
  padding-top: 3px;
  background-color: var(--color-0) !important;
  color: var(--text-color-1-light) !important;
}
</style>