export const STORAGE_KEY = 'app-theme-preference';
export const LIGHT_THEME = 'user-theme';
export const DARK_THEME = 'user-theme-dark';
export const PREFERENCES = Object.freeze(['system', 'light', 'dark']);

export function getThemePreference() {
  try {
    const value = localStorage.getItem(STORAGE_KEY);
    return PREFERENCES.includes(value) ? value : 'system';
  } catch {
    return 'system';
  }
}

export function setThemePreference(preference) {
  if (!PREFERENCES.includes(preference)) return;

  try {
    localStorage.setItem(STORAGE_KEY, preference);
  } catch {
    // private mode / blocked storage — preference still applies for this page
  }
}

export function resolvedTheme(preference = getThemePreference()) {
  if (preference === 'light') return LIGHT_THEME;
  if (preference === 'dark') return DARK_THEME;

  return window.matchMedia('(prefers-color-scheme: dark)').matches
    ? DARK_THEME
    : LIGHT_THEME;
}

export function applyThemePreference(preference = getThemePreference()) {
  document.documentElement.setAttribute(
    'data-theme',
    resolvedTheme(preference),
  );
}
