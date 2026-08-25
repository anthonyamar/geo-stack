# frozen_string_literal: true

# Quiet third-party warnings (shoulda-matchers frozen string) for a clean test output
$VERBOSE = nil

ENV["RAILS_ENV"] ||= "test"

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start "rails" do
    add_filter "/test/"

    if ENV["PARALLEL_WORKERS"]
      SimpleCov.command_name "rails_test_#{ENV["PARALLEL_WORKERS"]}"
    else
      SimpleCov.command_name "rails_test"
    end

    SimpleCov.use_merging true
    SimpleCov.merge_timeout 3600
    SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
  end
end

require_relative "../config/environment"
require "rails/test_help"
require_relative "support/parallelization_shutdown_timeout"
require "minitest/reporters"

Minitest::Reporters.use!(
  Minitest::Reporters::ProgressReporter.new,
  ENV,
  Minitest.backtrace_filter
)
Minitest.load :minitest_reporter

Rails::TestUnitReporter.class_eval do
  def format_rerun_snippet(result)
    location, line =
      if result.respond_to?(:source_location)
        result.source_location
      else
        result.method(result.name).source_location
      end
    "#{self.class.executable} #{relative_path_for(location)}:#{line}"
  end
end

require "capybara/rails"
require "capybara/minitest"

require "database_cleaner/active_record"
DatabaseCleaner.strategy = :truncation, { except: ["spatial_ref_sys"] }
DatabaseCleaner.clean_with :truncation, { except: ["spatial_ref_sys"] }

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors) unless ENV["COVERAGE"]

  Timezone::Lookup.config(:test).default("Europe/Paris")

  setup do
    DatabaseCleaner.start
    ActiveStorage::Current.url_options = { host: "test.host" }
    I18n.locale = I18n.default_locale
  end
  teardown do
    DatabaseCleaner.clean
  end

  fixtures :all

  include FactoryBot::Syntax::Methods

  def normalize_json(json)
    JSON.parse(json.to_json, symbolize_names: true)
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def skip_unless_devise_route!(route_name = :new_user_password)
    skip "Devise routes are not available" unless Rails.application.routes.routes.any? { it.name == route_name.to_s }
  end
end

def routes
  Rails.application.routes.url_helpers
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end

require "mocha/minitest"
