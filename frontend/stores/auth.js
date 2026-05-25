import { defineStore } from "pinia";
import axios from "axios";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    user: null,
    isAuthenticated: false,
    isInitialized: false,
  }),
  actions: {
    async checkAuth() {
      try {
        const response = await axios.get("/api/auth/check", {
          withCredentials: true,
        });
        this.user = response.data.user;
        this.isAuthenticated = true;
      } catch (error) {
        this.user = null;
        this.isAuthenticated = false;
      } finally {
        this.isInitialized = true;
      }
    },
  },
});
