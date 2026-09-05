<script>
export const UPDATES = [
  // Add every new announcement at the top with its own stable ID.
  {
    id: "5",
    changes: [
      "Expand your quote library with the quotes from your friends. You can make a quote private when adding or editing it.",
    ],
  },
  {
    id: "4",
    changes: ["Redesign of your friend's read corner."],
  },
];

export default {
  props: {
    updates: {
      type: Array,
      required: true,
    },
  },
};
</script>

<template>
  <div class="updates">
    <template v-if="updates.length">
      <div class="updates-header">
        <p class="latest-update">Latest update</p>
        <h1>What’s new in Ink Loft?</h1>
      </div>

      <div class="updates-section">
        <p>We have something special for you! Checkout these updates:</p>
        <article v-for="update in updates" :key="update.id">
          <ul>
            <li v-for="change in update.changes" :key="change">
              {{ change }}
            </li>
          </ul>
        </article>
      </div>
    </template>
  </div>
</template>

<style scoped>
.updates {
  max-height: 50vh;
  overflow-y: auto;

  article + article {
    margin-top: var(--gap-4);
  }

  .latest-update {
    margin: 0 0 var(--gap-1);
    color: var(--text-color-1-light);
    font-size: var(--font-size-2);
    text-transform: uppercase;
  }

  ul {
    padding-left: var(--gap-3);
    list-style: none;

    li {
      display: flex;
      align-items: center;
      gap: var(--gap-2);

      &::before {
        flex: 0 0 auto;
        content: "✨";
      }
    }
  }
}
</style>
