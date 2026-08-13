import path from "node:path";
import { PrimeVueResolver } from "@primevue/auto-import-resolver";
import vue from "@vitejs/plugin-vue";
import Components from "unplugin-vue-components/vite";
import { defineConfig, loadEnv } from "vite";
import { VitePWA } from "vite-plugin-pwa";

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), "");

  return {
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
        includeAssets: ["open-book.png", "icons/app-icon.png"],
        manifest: {
          name: "Ink Loft",
          short_name: "Ink Loft",
          description: "Ink Loft - Your personal book tracker",
          theme_color: "#1c1917",
          background_color: "#1c1917",
          display: "standalone",
          icons: [
            {
              src: "icons/app-icon.png",
              sizes: "192x192",
              type: "image/png",
            },
            {
              src: "icons/app-icon.png",
              sizes: "512x512",
              type: "image/png",
            },
            {
              src: "icons/app-icon.png",
              sizes: "512x512",
              type: "image/png",
              purpose: "any maskable",
            },
          ],
        },
        workbox: {
          globPatterns: ["**/*.{js,css,html,ico,png,svg}"],
        },
      }),
    ],
    resolve: {
      alias: {
        "@": path.resolve(__dirname, "./src"),
      },
    },
    server: {
      port: 8000,
      strictPort: true,
      proxy: {
        "/api": {
          target: "http://localhost:3000",
          changeOrigin: false,
        },
      },
    },
  };
});
