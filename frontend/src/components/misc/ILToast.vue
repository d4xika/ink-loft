<script setup></script>

<template>
  <Toast>
    <template #container="{ message, closeCallback }">
      <div class="toasti">
        <div class="left-container">
          <i class="pi pi-book"></i>
          <p class="font-fix">
            {{ message.message }}
          </p>
        </div>
        <div class="right-container">
          <i v-ripple class="pi pi-times" @click="closeCallback"></i>
        </div>
      </div>
    </template>
  </Toast>
</template>

<style>
.p-toast {
  max-width: 80vw !important;
}

.p-toast .p-toast-message-info,
.p-toast .p-toast-message-success {
  background-color: var(--color-3) !important;
  border: 1px solid var(--color-3) !important;
}

.p-toast .p-toast-message-error {
  background-color: var(--color-1) !important;
  border: 1px solid var(--color-1) !important;
}

.p-toast .p-toast-message-warn {
  background-color: var(--color-5) !important;
  border: 1px solid var(--color-5) !important;
}
</style>

<style scoped>
.toasti {
  display: flex;
  justify-content: space-between;
  padding: var(--gap-3);

  .left-container {
    display: flex;
    align-items: center;
    gap: var(--gap-3);
    color: var(--text-color-1) !important;

    p {
      margin: 0;
    }
  }

  .right-container {
    display: flex;
    align-items: center;
    color: var(--text-color-1-light) !important;
  }
}
</style>
