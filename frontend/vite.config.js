import path from 'node:path'
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
        dts: true
      }),
      VitePWA({
        registerType: "autoUpdate",
        manifest: {
          name: "Ink Loft",
          theme_color: "#1c1917",
        },
        workbox: {
          globPatterns: ["**/*.{js,css,html,ico,png,svg}"],
        },
      }),
    ],
    resolve: {
      alias: {
        '@': path.resolve(__dirname, './src'),
      },
    }
  };
});
