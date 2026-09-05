<script setup>
const props = defineProps({
  title: {
    type: String,
    required: true,
  },
});
const model = defineModel({ type: Boolean, default: false });
</script>

<template>
  <Drawer
    v-model:visible="model"
    :header="props.title"
    :closeButtonProps="{ severity: 'contrast', text: true, rounded: true }"
    position="bottom"
    style="height: fit-content"
  >
    <div class="divider-1">
      <ILDivider :width="100" />
      <div style="width: 3.75rem"></div>
    </div>
    <slot name="body"> </slot>
  </Drawer>
</template>

<style>
.p-drawer {
  border-top-left-radius: 10px !important;
  border-top-right-radius: 10px !important;
  border: none !important;
  margin: 0 var(--gap-2) !important;
  background-color: var(--color-0) !important;

  .divider-1 {
    display: flex;
    margin-bottom: var(--gap-4);
    margin-top: calc(var(--gap-2) * -1);
  }

  .p-drawer-header {
    padding-bottom: var(--gap-1);
    padding-top: var(--gap-3);
  }

  .p-drawer-content {
    padding-top: var(--gap-2);
  }
}
</style>
