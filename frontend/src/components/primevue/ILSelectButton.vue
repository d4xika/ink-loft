<script setup>
import { ref, watch, onMounted, onUnmounted, nextTick } from "vue";

const props = defineProps({
  options: {
    type: Array,
    required: true,
  },
  name: {
    type: String,
  },
  optionLabel: {
    type: String,
    default: undefined,
  },
  optionValue: {
    type: String,
    default: undefined,
  },
});

const model = defineModel({
  type: String,
});

const container = ref(null);
const sliderStyle = ref({
  width: "0px",
  left: "0px",
});

const updateSlider = async () => {
  await nextTick();
  if (!container.value) return;

  const checkedButton = container.value.querySelector(
    ".p-togglebutton-checked",
  );
  if (checkedButton) {
    sliderStyle.value = {
      width: `${checkedButton.offsetWidth}px`,
      left: `${checkedButton.offsetLeft}px`,
    };
  }
};

watch(model, updateSlider);

onMounted(() => {
  updateSlider();
  window.addEventListener("resize", updateSlider);
});

onUnmounted(() => {
  window.removeEventListener("resize", updateSlider);
});
</script>

<template>
  <div ref="container" class="il-select-button-wrapper">
    <div class="slider" :style="sliderStyle"></div>
    <SelectButton
      v-model="model"
      :options="props.options"
      :allowEmpty="false"
      :name="props.name"
      :optionLabel="props.optionLabel"
      :optionValue="props.optionValue"
    />
  </div>
</template>

<style scoped lang="scss">
.il-select-button-wrapper {
  position: relative;
  display: inline-flex;
  background-color: var(--color-0);
  border-radius: var(--border-radius-1);
  padding: var(--gap-1);

  .slider {
    position: absolute;
    top: var(--gap-1);
    bottom: var(--gap-1);
    background-color: var(--color-3);
    border-radius: calc(var(--border-radius-1) - var(--gap-1));
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    z-index: 0;
    pointer-events: none;
  }
}

.p-selectbutton {
  z-index: 1;
  background-color: transparent !important;
  border: none !important;

  &:hover {
    background-color: transparent !important;
  }

  :deep(.p-togglebutton) {
    background-color: transparent !important;
    font-size: var(--font-size-2);
    padding: 0;
    border: 1px solid var(--color-2) !important;
    border-radius: calc(var(--border-radius-1) - var(--gap-1)) !important;

    &.p-togglebutton-checked {
      background-color: transparent !important;
    }
  }

  :deep(.p-togglebutton-content) {
    padding: var(--gap-1) var(--gap-3);
    border-radius: calc(var(--border-radius-1) - var(--gap-1)) !important;
    transition: none;

    &[data-p="checked"] {
      background-color: transparent !important;
    }

    .p-togglebutton-label {
      font-size: var(--font-size-3);
      padding-top: 3px;
      position: relative;
      z-index: 2;
      transition: color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      color: var(--color-4);
    }
  }
}
</style>
