<script setup>
import { useRouter } from "vue-router";

const props = defineProps({
  reads: {
    type: Object,
    required: true,
  },
});

const router = useRouter();
</script>

<template>
  <div class="reads-list">
    <div v-for="read in props.reads" :key="read.id">
      <div class="read-container">
        <ILBookCover
          :cover="read.cover_url ?? undefined"
          @click="router.push({ name: 'showRead', params: { id: read.id } })"
        />
      </div>
    </div>
  </div>
</template>

<style scoped>
.reads-list {
  display: flex;
  justify-content: center;

  flex-wrap: wrap;
  gap: var(--gap-3);

  .read-container {
    width: 120px;
  }
}
</style>
