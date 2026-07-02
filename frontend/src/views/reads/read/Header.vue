<script setup>
import { useRouter } from "vue-router";

const props = defineProps({
  saveButtonEnabled: {
    type: Boolean,
    default: false,
  },
  editButtonEnabled: {
    type: Boolean,
    default: false,
  },
});

const router = useRouter();

const emit = defineEmits(["edit"]);
</script>

<template>
  <div class="header-container">
    <ILIconButton
      icon="pi-chevron-left"
      variant="square"
      @click="router.go(-1)"
    />
    <ILIconButton
      :icon="props.saveButtonEnabled ? 'pi-save' : 'pi-pen-to-square'"
      variant="square"
      :type="props.saveButtonEnabled ? 'submit' : 'button'"
      @click="props.saveButtonEnabled ? undefined : emit('edit')"
    />
  </div>
</template>

<style scoped>
.header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: var(--gap-3);
}
</style>
