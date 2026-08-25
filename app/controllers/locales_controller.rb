# frozen_string_literal: true

class LocalesController < ApplicationController
  skip_before_action :redirect_to_preferred_locale

  def update
    locale = permitted_locale
    session[LocaleConcern::LOCALE_SESSION_KEY] = locale

    redirect_to Locale::Path.for(safe_return_to_path, locale: locale.to_sym)
  end

  private

  def permitted_locale
    locale = params[:locale].to_s
    return locale if I18n.available_locales.map(&:to_s).include?(locale)

    I18n.default_locale.to_s
  end

  def safe_return_to_path
    Locale::Path.safe_return(
      params[:return_to].presence || request.referer.presence || root_path
    )
  end
end
