<script setup>
import { onMounted, ref } from "vue";

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

const swipeContainer = ref(null);

onMounted(() => {
  if (swipeContainer.value) {
    swipeContainer.value.scrollLeft = 0;
  }
});

const emit = defineEmits(["edit", "delete"]);
</script>

<template>
  <div ref="swipeContainer" class="swipe-wrapper">
    <div class="swipe-main">
      <div class="quotes-container">
        <div class="left-container">
          <div>
            <i class="pi pi-pen-to-square"></i>
          </div>
          <div>
            <h2 class="quote">
              "{{ props.quote }}"
            </h2>
            <h3 class="source">
              {{ props.source }}
            </h3>
          </div>
        </div>
      </div>
      <i class="pi pi-angle-right swipe-indicator"></i>
    </div>

    <div class="swipe-actions">
      <ILIconButton
        icon="pi-pencil"
        class="edit-button"
        @click="emit('edit')"
      />
      <ILIconButton
        icon="pi-trash"
        class="delete-button"
        @click="emit('delete')"
      />
    </div>
  </div>
</template>

<style scoped>
.swipe-wrapper {
  display: flex;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  gap: var(--gap-3);
  scrollbar-width: none;

  &::-webkit-scrollbar {
    display: none;
  }

  .swipe-main {
    display: flex;
    align-items: center;
    flex-shrink: 0;
    scroll-snap-align: start;
    gap: var(--gap-2);
    width: 100%;

    .swipe-indicator {
      width: var(--font-size-2);
      color: var(--text-color-1-light);
    }
  }

  .swipe-actions {
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: var(--gap-2);
    flex-shrink: 0;
    scroll-snap-align: end;

    .edit-button {
      background-color: var(--color-3);
      padding: 0 var(--gap-3);
    }

    .delete-button {
      background-color: var(--color-1);
      padding: 0 var(--gap-3);
    }
  }
}

.quotes-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: var(--gap-3);
  border: 1px solid var(--color-2);
  border-radius: var(--border-radius-1);
  padding: var(--gap-3);
  width: 100%;

  .left-container {
    display: flex;
    align-items: center;
    gap: var(--gap-3);

    i {
      background-color: var(--color-2);
      padding: var(--gap-3);
      border-radius: var(--border-radius-1);
      font-size: var(--font-size-4);
    }

    .quote {
      font-family: "EB Garamond", serif;
      font-style: italic;
      font-size: var(--font-size-4);
      margin: 0;
      padding-bottom: var(--gap-2);
    }

    .source {
      font-size: var(--font-size-2);
      color: var(--text-color-1-light);
    }
  }
}
</style>
