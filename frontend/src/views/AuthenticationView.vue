<script setup>
import { ref } from "vue";
import ILSelectButton from "../components/primevue/ILSelectButton.vue";

const tab = ref("LOGIN");
const tabOptions = ["LOGIN", "REGISTER"];

const username = ref("");
</script>

<template>
  <div class="authentication-view-container">
    <h1>Welcome Reader</h1>
    <div class="content">
      <div>Logo</div>
      <ILSelectButton v-model="tab" :options="tabOptions"></ILSelectButton>

      <ILTextInput label="Username" v-model="username"></ILTextInput>
    </div>
  </div>
</template>

<style scoped lang="scss">
.authentication-view-container {
  display: flex;
  flex-direction: column;
  height: 100dvh;

  h1 {
    margin-top: 2rem;
    margin-left: 1rem;
    flex-grow: 0;
    font-size: 2rem;
  }
  .content {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    gap: var(--gap-4);
  }
}
</style>
