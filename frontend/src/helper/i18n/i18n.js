import { createI18n } from "vue-i18n";
import { de } from "./languages/de.js";
import { en } from "./languages/en.js";
import { noe } from "./languages/noe.js";
import { sue } from "./languages/sue.js";

export const i18n = createI18n({
  legacy: false,
  locale: "en",
  fallbackLocale: "en",
  messages: {
    en: en,
    de: de,
    noe: noe,
    sue: sue,
  },
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
