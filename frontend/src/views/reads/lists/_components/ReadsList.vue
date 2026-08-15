<script setup>
import { computed } from "vue";
import { useRouter } from "vue-router";

const props = defineProps({
  reads: {
    type: Object,
    required: true,
  },
  sortBy: {
    type: String,
    default: "date",
    validator: (value) => ["title", "author", "pairing", "date"].includes(value),
  },
});

const router = useRouter();
const sortedReads = computed(() => {
  if (!Array.isArray(props.reads)) return [];

  return [...props.reads].sort((left, right) => {
    if (props.sortBy === "date") {
      const leftDate = new Date(left.start_date || left.created_at || 0).getTime();
      const rightDate = new Date(right.start_date || right.created_at || 0).getTime();
      return rightDate - leftDate;
    }

    return String(left[props.sortBy] || "").localeCompare(
      String(right[props.sortBy] || ""),
      undefined,
      { sensitivity: "base" },
    );
  });
});
</script>

<template>
  <div v-if="props.reads.length <= 0" class="no-reads-image-container">
    <img src="/images/drawings/kitty_on_shelf.png" alt="Kitty on shelf" />
  </div>

  <div v-if="props.reads" class="reads-list">
    <template v-if="props.reads.loading">
      <div v-for="read in 6" :key="read">
        <Skeleton width="130px" height="170px" />
      </div>
    </template>

    <template v-else>
      <div v-for="read in sortedReads" :key="read.id">
        <div class="read-container">
          <ILReadCover
            :loading="props.reads.loading"
            :cover="read.cover_small_url ?? undefined"
            @click="router.push({ name: 'showRead', params: { id: read.id } })"
          />
          <p>{{ read.title }}</p>
        </div>
      </div>
    </template>
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
  padding-bottom: var(--gap-2);

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
