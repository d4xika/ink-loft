<script setup>
const props = defineProps({
  new: {
    type: Boolean,
    default: false,
  },
  action: {
    type: String,
    default: "",
  },
  description: {
    type: String,
    default: "",
  },
  avatarUrl: {
    type: String,
    default: undefined,
  },
  username: {
    type: String,
    default: undefined,
  },
});
</script>

<template>
  <div class="activity-container" :class="{ new: props.new }">
    <div class="avatar" :class="{ 'has-new-badge': props.new }">
      <ILAvatar :image="props.avatarUrl" :username="props.username" />
    </div>
    <div>
      <h3>{{ props.username }}</h3>
      <p class="action">
        {{ props.action }}
        <span class="description">{{ props.description }}</span>
      </p>
    </div>
  </div>
</template>

<style scoped>
.activity-container {
  display: flex;
  align-items: center;
  gap: var(--gap-3);
  padding: var(--gap-2);
  border-radius: var(--border-radius-1);
  margin: 0;

  &.new {
    background-color: var(--color-2);
  }

  .avatar {
    display: flex;
    position: relative;
    flex-shrink: 0;

    &.has-new-badge::after {
      content: "";
      position: absolute;
      top: -0.2rem;
      right: -0.2rem;
      width: 0.75rem;
      height: 0.75rem;
      border: 2px solid var(--color-2);
      border-radius: 50%;
      background-color: var(--color-1-bright);
    }
  }

  .action {
    font-size: var(--font-size-2);
    margin: 0;
  }

  .description {
    font-style: italic;
    color: var(--text-color-1-light);
    margin: 0;
  }
}
</style>
