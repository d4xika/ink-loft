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
  <div v-if="props.reads.length <= 0" class="no-reads-image-container">
    <img src="/images/drawings/kitty_on_shelf.png" alt="Kitty on shelf" />
  </div>

  <div class="reads-list" v-if="props.reads">
    <div v-if="props.reads.loading" v-for="read in 6" :key="read.id">
      <Skeleton width="130px" height="170px" />
    </div>

    <div v-else v-for="read in props.reads" :key="read.id">
      <div class="read-container">
        <ILReadCover
          :loading="props.reads.loading"
          :cover="read.cover_small_url ?? undefined"
          @click="router.push({ name: 'showRead', params: { id: read.id } })"
        />
        <p>{{ read.title }}</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.no-reads-image-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding-top: 5dvh;

  img {
    height: 20dvh;
  }
}

.reads-list {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: var(--gap-3);

  .read-container {
    width: 120px;

    p {
      margin: 0;
      padding: var(--gap-1);
      text-align: center;
      font-size: var(--font-size-2);
      text-wrap: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
  }
}
</style>
