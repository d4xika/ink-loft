<script setup>
const props = defineProps({
  name: {
    type: String,
    required: true,
  },
  label: {
    type: String,
    required: true,
  },
});
const model = defineModel({ type: Boolean, default: false });
</script>

<template>
  <div class="toggle-switch-container">
    <p>{{ props.label }}</p>
    <ToggleSwitch v-model="model" v-ripple :name="props.name">
      <template #handle="{ checked }">
        <i
          :class="[
            '!text-xs pi',
            { 'pi-check': checked, 'pi-times': !checked },
          ]"
        ></i>
      </template>
    </ToggleSwitch>
  </div>
</template>

<style scoped>
.toggle-switch-container {
  display: flex;
  align-items: center;
  gap: var(--gap-3);
  justify-content: space-between;
  border: 1px solid var(--color-2);
  padding: 0 var(--gap-2);
  border-radius: var(--p-inputtext-border-radius);
}

:deep(.p-toggleswitch-checked) .p-toggleswitch-slider {
  background-color: var(--color-3) !important;
}
</style>
