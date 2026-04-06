<script setup>
import Header from "./_components/Header.vue";
</script>

<template>
  <div>
    <Header />
    <div class="profile-view-content">
      <ILImageUploader />
    </div>
  </div>
</template>

<style scoped>
.profile-view-content {
  margin-top: var(--gap-5);
}
</style>
