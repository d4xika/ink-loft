import Aura from "@primevue/themes/aura";
import PrimeVue from "primevue/config";
import ToastService from "primevue/toastservice";
import { createApp } from "vue";
import App from "./App.vue";
import { i18n } from "./helper/i18n/i18n.js";
import router from "./router/router.js";
import "./core.scss";
import "primeicons/primeicons.css";
import { definePreset, palette } from "@primevue/themes";

const primary = palette("#464832");

const preset = definePreset(Aura, {
  semantic: {
    primary,
  },
});

const app = createApp(App);

app.use(router);
app.use(PrimeVue, {
  theme: {
    preset: preset,
    options: {
      prefix: "p",
      darkModeSelector: "system",
      cssLayer: false,
    },
  },
});
app.use(ToastService);
app.use(i18n);
setTimeout(() => {
  app.mount("#app");
}, 1000);
