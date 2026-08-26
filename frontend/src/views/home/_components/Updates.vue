<script>
export const UPDATE_VERSION = "3";
</script>

<template>
  <div class="updates">
    <div class="updates-header">
      <p class="latest-update">Latest update</p>
      <h1>What’s new in Ink Loft?</h1>
    </div>

    <div class="updates-section">
      <p>We have something special for you! Checkout these updates:</p>
      <ul>
        <li>New Update button.</li>
        <li>Changed adding friends process.</li>
        <li>Restyled Topbar.</li>
        <li>Press your username three times for some magic.</li>
        <li>Save reads from a friend to your own list.</li>
      </ul>
    </div>
  </div>
</template>

<style scoped>
.updates {
  max-height: 50vh;
  overflow-y: auto;

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
