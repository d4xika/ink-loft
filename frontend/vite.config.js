import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import { VitePWA } from "vite-plugin-pwa";
import Components from "unplugin-vue-components/vite";
import { PrimeVueResolver } from "@primevue/auto-import-resolver";

export default defineConfig({
  plugins: [
    vue(),
    Components({
      resolvers: [PrimeVueResolver()],
      dirs: ["src/components", "src/views/sections"],
      extensions: ["vue"],
      deep: true,
      dts: true,
    }),
    VitePWA({
      registerType: "autoUpdate",
      manifest: {
        name: "Ink Loft",
        theme_color: "red",
      },
      workbox: {
        globPatterns: ["**/*.{js,css,html,ico,png,svg}"],
      },
    }),
  ],
});
