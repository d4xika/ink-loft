<script setup>
import { onBeforeUnmount, ref, useId } from "vue";

const props = defineProps({
  color: {
    type: String,
    default: "green",
    validator: (value) =>
      [
        "green",
        "red",
        "brown-1",
        "brown-2",
        "brown-3",
        "brown-4",
        "white",
      ].includes(value),
  },
  text: {
    type: [String, Number],
    required: true,
  },
  icon: {
    type: String,
    default: undefined,
  },
  image: {
    type: String,
    default: undefined,
  },
  size: {
    type: String,
    default: "small",
    validator: (value) => ["small", "big"].includes(value),
  },
  tooltip: {
    type: String,
    default: undefined,
  },
});

const tooltipId = `il-tag-tooltip-${useId()}`;
const tooltipVisible = ref(false);
let tooltipTimeout;

function showTooltip() {
  if (!props.tooltip) {
    return;
  }

  clearTimeout(tooltipTimeout);
  tooltipVisible.value = true;
  tooltipTimeout = setTimeout(() => {
    tooltipVisible.value = false;
  }, 2000);
}

function toggleTooltip() {
  showTooltip();
}

onBeforeUnmount(() => clearTimeout(tooltipTimeout));
</script>

<template>
  <div class="tag-wrapper">
    <div
      :class="`color-${props.color} size-${props.size}`"
      class="tag"
      @click="toggleTooltip"
    >
      <div v-if="props.image || props.icon" class="icon-container">
        <img
          v-if="props.image"
          :src="props.image"
          class="tag-image"
          alt="tag icon"
        />
        <i v-else-if="props.icon" :class="`pi ${props.icon}`" class="icon"></i>
      </div>
      <p class="text">{{ props.text }}</p>
    </div>
    <div
      v-if="props.tooltip"
      class="tooltip"
      :class="{ visible: tooltipVisible }"
    >
      {{ props.tooltip }}
    </div>
  </div>
</template>

<style scoped>
.tag-wrapper {
  position: relative;

  .tag {
    display: flex;
    align-items: center;
    overflow: hidden;
    word-break: break-word;
    color: var(--text-color);

    & + .tooltip.visible {
      visibility: visible;
      opacity: 0.9;
    }

    &.color-green {
      background-color: var(--color-3);
    }

    &.color-red {
      background-color: var(--color-1);
    }

    &.color-white {
      background-color: var(--text-color-1-light);
      color: var(--color-0);
    }

    &.color-brown-1 {
      background-color: var(--color-7);
    }

    &.color-brown-2 {
      background-color: var(--color-4);
    }

    &.color-brown-3 {
      background-color: var(--color-5);
    }

    &.color-brown-4 {
      background-color: var(--color-6);
    }

    &.size-small {
      gap: var(--gap-2);
      padding: var(--gap-1) calc(var(--gap-1) + var(--gap-2));
      border-radius: var(--border-radius-2);

      .icon-container {
        display: flex;
        align-items: center;
        justify-content: center;

        .icon {
          font-size: var(--font-size-2);
          margin-top: 1px;
        }

        .tag-image {
          height: 20px;
        }
      }

      .text {
        margin: 0;
        padding-top: 1px;
        font-size: var(--font-size-2);
      }
    }

    &.size-big {
      gap: var(--gap-3);
      padding: var(--gap-1) calc(var(--gap-1));
      width: 100%;
      border-radius: var(--border-radius-1);

      .icon-container {
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: color-mix(in srgb, black 45%, var(--color-3));
        padding: var(--gap-2);
        border-radius: var(--border-radius-1);

        .icon {
          font-size: var(--font-size-3);
        }

        .tag-image {
          height: 30px;
        }
      }

      .text {
        margin: 0;
        padding-top: 3px;
        font-size: var(--font-size-4);
      }
    }
  }

  .tooltip {
    position: absolute;
    z-index: 1;
    bottom: calc(100% + var(--gap-2));
    left: 50%;
    padding: var(--gap-2) var(--gap-3);
    border-radius: var(--border-radius-2);
    background-color: var(--color-2);
    color: var(--text-color-1-light);
    font-size: var(--font-size-2);
    transform: translateX(-50%);
    transition: 400ms ease-in-out;
    visibility: hidden;
    opacity: 0;
  }
}
</style>
