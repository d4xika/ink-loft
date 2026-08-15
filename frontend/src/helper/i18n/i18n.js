import { createI18n } from "vue-i18n";
import { de } from "./languages/de.js";
import { en } from "./languages/en.js";
import { noe } from "./languages/noe.js";
import { sue } from "./languages/sue.js";

const messages = {
  en: en,
  de: de,
  noe: noe,
  sue: sue,
};

function storedLocale() {
  try {
    const language = JSON.parse(localStorage.getItem("user"))?.language;
    return Object.hasOwn(messages, language) ? language : "en";
  } catch {
    return "en";
  }
}

export const i18n = createI18n({
  legacy: false,
  locale: storedLocale(),
  fallbackLocale: "en",
  messages,
  numberFormats: {
    en: {
      decimal: {
        style: "decimal",
        useGrouping: true,
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
      },
    },
    de: {
      decimal: {
        style: "decimal",
        useGrouping: true,
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
      },
    },
    noe: {
      decimal: {
        style: "decimal",
        useGrouping: true,
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
      },
    },
    sue: {
      decimal: {
        style: "decimal",
        useGrouping: true,
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
      },
    },
  },
});

export function setLocale(language) {
  if (Object.hasOwn(messages, language)) {
    i18n.global.locale.value = language;
  }
}

export const languages = [
  {
    label: "English",
    value: "en",
    image: "/images/flags/en.svg",
  },
  {
    label: "Deutsch",
    value: "de",
    image: "/images/flags/de.svg",
  },
  {
    label: "Niederösterreichisch",
    value: "noe",
    image: "/images/flags/noe.svg",
  },
  {
    label: "Südtirolerisch",
    value: "sue",
    image: "/images/flags/sue.svg",
  },
];
