# frozen_string_literal: true

module LocaleConcern
  extend ActiveSupport::Concern

  LOCALE_SESSION_KEY = :locale
  LOCALE_PARAM = "fr"

  NON_LOCALIZED_PATH_PREFIXES = %w[/jobs /letter_opener /devtools /users].freeze

  included do
    before_action :redirect_to_preferred_locale, if: :redirect_for_accept_language?
    before_action :set_locale
    before_action :redirect_to_canonical_locale_path, if: :canonical_locale_redirect_needed?
  end

  private

  def set_locale
    I18n.locale = resolved_locale
    persist_locale_in_session if public_locale_scoped_request?
  end

  def resolved_locale
    return :fr if params[:locale] == LOCALE_PARAM

    stored = locale_from_session
    return stored if stored

    return :en if public_locale_scoped_request? && params[:locale].blank?

    :en
  end

  def locale_from_session
    session_locale = session[LOCALE_SESSION_KEY].presence
    return unless session_locale
    return unless I18n.available_locales.map(&:to_s).include?(session_locale)

    session_locale.to_sym
  end

  def public_locale_scoped_request?
    path = request.path.sub(%r{\A/fr(?=/|$)}, "")
    path = "/" if path.blank?
    !Locale::Path.non_localized?(path)
  end

  def redirect_for_accept_language?
    return false unless request.get? || request.head?
    return false unless public_locale_scoped_request?
    return false if locale_from_session.present?
    return false if params[:locale].present?
    return false if request.path.start_with?("/fr")

    preferred_french?
  end

  def preferred_french?
    AcceptLanguage.preferred?(request.headers["Accept-Language"], locale: "fr")
  end

  def redirect_to_preferred_locale
    session[LOCALE_SESSION_KEY] = "fr"
    redirect_to Locale::Path.for(request.fullpath, locale: :fr)
  end

  def canonical_locale_redirect_needed?
    return false unless request.get? || request.head?
    return false unless public_locale_scoped_request?
    return false if request.path.start_with?("/locale")
    return false if params[:locale] == LOCALE_PARAM
    return false if turbo_navigation_request?

    I18n.locale == :fr
  end

  def turbo_navigation_request?
    turbo_frame_request? || request.format.turbo_stream?
  end

  def redirect_to_canonical_locale_path
    redirect_to Locale::Path.for(request.fullpath, locale: :fr), status: :found
  end

  def persist_locale_in_session
    session[LOCALE_SESSION_KEY] = I18n.locale.to_s
  end
end
