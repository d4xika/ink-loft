<script setup>
const props = defineProps({
  options: {
    type: Array,
    required: true,
  },
});

const model = defineModel({
  type: String,
  required: true,
});
</script>

<template>
  <SelectButton
    v-model="model"
    :options="props.options"
    :allow-empty="false"
  />
</template>

<style scoped lang="scss">
.p-selectbutton {
  &:hover {
    background-color: var(--color-0) !important;
  }

  :deep(.p-togglebutton) {
    background-color: var(--color-0);
    font-size: var(--font-size-2);
    padding: var(--gap-1);
    border: none;

    &:hover {
      background-color: var(--color-0) !important;
    }

    &:first-child {
      border-radius: var(--border-radius-1) 0 0 var(--border-radius-1) !important;
    }

    &:last-child {
      border-radius: 0 var(--border-radius-1) var(--border-radius-1) 0 !important;
    }

    &.p-togglebutton-checked {
      background-color: var(--color-0) !important;
      border: none;
    }
  }

  :deep(.p-togglebutton-content) {
    padding: var(--gap-1) var(--gap-3);
    border-radius: calc(var(--border-radius-1) - var(--gap-1)) !important;

    &[data-p="checked"] {
      background-color: var(--color-3) !important;
    }
    .p-togglebutton-label {
      font-size: var(--font-size-3);
      padding-top: 3px;
    }
  }
}
</style>
