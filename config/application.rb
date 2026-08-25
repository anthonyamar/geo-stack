# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in the Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GeoStack
  # Public hostname (mail From, mailer URLs, sitemap). Change only here.
  APP_NAME = "Your Website Name"
  DOMAIN = "example.com"
  MAILER_FROM_ADDRESS = "humans@#{DOMAIN}".freeze
  MAILER_FROM = "#{APP_NAME} <#{MAILER_FROM_ADDRESS}>".freeze

  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # I18n
    config.i18n.available_locales = %i[en fr]
    config.i18n.default_locale = :en

    # Nested locales + component sidecars with absolute scopes.
    # Flat top-level keys in component YAML can collide — see i18n_load_path.rb.
    config.i18n.load_path += Rails.root.glob("config/locales/**/*.{rb,yml}")
    config.i18n.load_path += Rails.root.glob("app/views/**/*.{rb,yml}")
    config.i18n.load_path += Rails.root.glob("app/components/**/*.yml")

    # Handle dynamically the errors (exceptions) raised
    config.exceptions_app = routes

    # Configuration Active Job with Solid Queue
    config.active_job.queue_adapter = :solid_queue

    # Configuration Solid Queue to use the same database
    config.solid_queue.connects_to = { database: { writing: :primary, reading: :primary } }

    config.assets.initialize_on_precompile = false
  end
end
