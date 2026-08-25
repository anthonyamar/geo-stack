import { Controller } from '@hotwired/stimulus';
import {
  PREFERENCES,
  applyThemePreference,
  getThemePreference,
  setThemePreference,
} from '../lib/theme';

export default class extends Controller {
  static targets = ['option'];

  connect() {
    this.syncOptions(getThemePreference());

    this.mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
    this.onSystemChange = () => {
      if (getThemePreference() === 'system') {
        applyThemePreference('system');
      }
    };
    this.mediaQuery.addEventListener('change', this.onSystemChange);
  }

  disconnect() {
    this.mediaQuery?.removeEventListener('change', this.onSystemChange);
  }

  select(event) {
    const { preference } = event.params;
    if (!PREFERENCES.includes(preference)) return;

    setThemePreference(preference);
    applyThemePreference(preference);
    this.syncOptions(preference);
  }

  syncOptions(preference) {
    this.optionTargets.forEach((option) => {
      const active = option.dataset.themePreferenceParam === preference;
      option.classList.toggle('btn-active', active);
      option.setAttribute('aria-pressed', active ? 'true' : 'false');
    });
  }
}
