# frozen_string_literal: true

require "minitest/reporters"
require "simplecov"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'capybara/rails'
require 'capybara/minitest'

SimpleCov.start
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require "database_cleaner/active_record"
DatabaseCleaner.strategy = :truncation, { except: ["spatial_ref_sys"] }
DatabaseCleaner.clean_with :truncation, { except: ["spatial_ref_sys"] }

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)
  setup { DatabaseCleaner.start }
  teardown { DatabaseCleaner.clean }

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryBot::Syntax::Methods

  def normalize_json(json)
    JSON.parse(json.to_json, symbolize_names: true)
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # Make `assert_*` methods behave like Minitest assertions
  include Capybara::Minitest::Assertions

  # Reset sessions and driver between tests
  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
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
