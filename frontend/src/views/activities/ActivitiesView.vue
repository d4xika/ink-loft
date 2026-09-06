<script setup>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import API from "@/helper/api.js";
import Activity from "@/views/activities/_components/Activity.vue";
import Header from "@/views/activities/_components/Header.vue";

const activities = ref([]);
const { t } = useI18n();

async function getActivities() {
  const response = await API.get("/activities");
  activities.value = response.data;
  await API.put("/users/update_last_activity_check");
}

getActivities();
</script>

<template>
  <Header />
  <div class="activities-container">
    <h1>{{ t("activity.activities") }}</h1>
    <p v-if="activities">{{ t("activity.add_friend_hint") }}</p>
    <div v-for="activity in activities" :key="activity.id" class="activity">
      <Activity
        :new="activity.new"
        :action="t(`activity.${activity.action}`)"
        :description="activity.description"
        :avatarUrl="activity.avatar_url"
        :username="activity.username"
      />
      <ILDivider width="100" />
    </div>
  </div>
</template>

<style scoped>
.activities-container {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  padding: var(--gap-2) var(--gap-4);
  gap: var(--gap-3);

  .activity {
    display: flex;
    flex-direction: column;
    gap: var(--gap-3);
    width: 100%;
  }
}
</style>
