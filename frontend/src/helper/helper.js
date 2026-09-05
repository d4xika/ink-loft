const DEFAULT_THEME = "dark";
const THEMES = [DEFAULT_THEME, "light"];

export function new_line_to_br(text) {
  return text.replace(/\n/g, "<br/>");
}

export function setTheme(theme = DEFAULT_THEME) {
  document.documentElement.classList.remove(...THEMES);
  document.documentElement.classList.add(theme);
}
