# frozen_string_literal: true

module LocaleHelper
  def localized_path_for(path, locale: I18n.locale)
    Locale::Path.for(path, locale: locale)
  end

  def locale_switch_path(locale)
    locale_path(locale: locale.to_s, return_to: request.fullpath)
  end

  def hreflang_alternate_urls
    {
      en: absolute_localized_url(:en),
      fr: absolute_localized_url(:fr),
      'x-default': absolute_localized_url(:en)
    }
  end

  def current_locale_label
    t("nav.locale.#{I18n.locale}")
  end

  private

  def absolute_localized_url(locale)
    path = localized_path_for(request.fullpath, locale: locale)
    "#{request.base_url}#{path}"
  end
end
