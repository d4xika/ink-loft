import { definePreset, palette } from "@primevue/themes";
import Aura from "@primevue/themes/aura";
import PrimeVue from "primevue/config";
import ToastService from "primevue/toastservice";
import { createApp } from "vue";
import VueDOMPurifyHTML from "vue-dompurify-html";
import App from "./App.vue";
import { i18n } from "./helper/i18n/i18n.js";
import router from "./router/router.js";
import "./core.scss";
import "primeicons/primeicons.css";

const primary = palette("#464832");
const lightSurface = palette("#5a4438");
const darkSurface = palette("#71717a");

const preset = definePreset(Aura, {
  semantic: {
    primary,
    colorScheme: {
      light: {
        surface: lightSurface,
      },
      dark: {
        surface: darkSurface,
      },
    },
  },
});

const app = createApp(App);

app.use(router);
app.use(PrimeVue, {
  theme: {
    preset,
    options: {
      prefix: "p",
      darkModeSelector: ".dark",
      cssLayer: false,
    },
  },
});
app.use(ToastService);
app.use(i18n);
app.use(VueDOMPurifyHTML);
setTimeout(() => {
  app.mount("#app");
}, 1000);
