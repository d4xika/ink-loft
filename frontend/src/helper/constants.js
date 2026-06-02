import { useI18n } from "vue-i18n";

const { t } = useI18n();

export const READING_STATUSES = [
  {
    id: "want_to_read",
    label: t("read.want_to_read"),
  },
  {
    id: "currently_reading",
    label: t("read.currently_reading"),
  },
  {
    id: "have_read",
    label: t("read.finished"),
  },
  {
    id: "dropped",
    label: t("read.dropped"),
  },
];
