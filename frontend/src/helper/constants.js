import { i18n } from "./i18n/i18n.js";

export const READING_STATUSES = [
  {
    id: "want_to_read",
    label: i18n.global.t("read.reading_status.want_to_read"),
  },
  {
    id: "currently_reading",
    label: i18n.global.t("read.reading_status.currently_reading"),
  },
  {
    id: "have_read",
    label: i18n.global.t("read.reading_status.finished"),
  },
  {
    id: "dropped",
    label: i18n.global.t("read.reading_status.dropped"),
  },
];
