# frozen_string_literal: true

module Locale::Path
  DEVISE_USER_PREFIXES = %w[
    /users/sign_in
    /users/sign_out
    /users/sign_up
    /users/password
    /users/confirmation
    /users/cancel
    /users/edit
  ].freeze
  NON_LOCALIZED_PREFIXES = %w[/jobs /letter_opener /devtools].freeze

  module_function

  def for(path, locale: I18n.locale)
    path_string = path.to_s
    uri = URI.parse(path_string)
    path_only = uri.path.presence || path_string
    query = uri.query.present? ? "?#{uri.query}" : ""

    stripped_path = path_only.sub(%r{\A/fr(?=/|$)}, "")
    stripped_path = "/" if stripped_path.blank?

    return "#{stripped_path}#{query}" if non_localized?(stripped_path)

    localized_path = if locale.to_sym == :fr
                       stripped_path == "/" ? "/fr" : "/fr#{stripped_path}"
                     else
                       stripped_path
                     end

    "#{localized_path}#{query}"
  end

  def non_localized?(path)
    return true if NON_LOCALIZED_PREFIXES.any? { |prefix| path.start_with?(prefix) }
    return true if path == "/users"

    DEVISE_USER_PREFIXES.any? { |prefix| path.start_with?(prefix) }
  end

  def safe_return(path, fallback: "/")
    path_string = path.to_s
    return fallback unless path_string.start_with?("/")
    return fallback if path_string.start_with?("//")

    path_string
  end
end
