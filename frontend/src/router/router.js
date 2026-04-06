import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/home/HomeView.vue";
import ProfileView from "../views/profile/ProfileView.vue";

const AuthenticationView = () => import("../views/AuthenticationView.vue");

const routes = [
  {
    path: "/",
    name: "authentication",
    component: AuthenticationView,
  },
  {
    path: "/home",
    name: "home",
    component: () => HomeView,
  },
  {
    path: "/profile",
    name: "profile",
    component: () => ProfileView,
  },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition;
    } else {
      return { top: 0 };
    }
  },
});

export default router;
