# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

class GeoStack::Application < Rails::Application
  # Initialize configuration defaults for originally generated Rails version.
  config.load_defaults 7.2

  # Please, add to the `ignore` list any other `lib` subdirectories that do
  # not contain `.rb` files, or that should not be reloaded or eager loaded.
  # Common ones are `templates`, `generators`, or `middleware`, for example.
  config.autoload_lib(ignore: %w[assets tasks])

  # Configuration for the application, engines, and railties goes here.
  #
  # These settings can be overridden in specific environments using the files
  # in config/environments, which are processed later.
  #
  # config.time_zone = "Central Time (US & Canada)"
  # config.eager_load_paths << Rails.root.join("extras")
  config.active_support.to_time_preserves_timezone = :zone

  # I18n
  config.i18n.available_locales = %i[fr en]
  config.i18n.default_locale = :fr

  # Load the translations from the views
  config.i18n.load_path += Rails.root.glob("config/locales/**/*.{rb,yml}")
  config.i18n.load_path += Rails.root.glob("app/views/**/*.{rb,yml}")

  # Handle dynamicaly the errors (exceptions) raised
  config.exceptions_app = self.routes

  config.assets.initialize_on_precompile = false
end
