# frozen_string_literal: true

ENV["TEST_TYPE"] = "system"
require "test_helper"

Capybara.register_driver :chrome_headless do |app|
  chrome_options_args = %w[
    disable-gpu
    no-sandbox
    window-size=1400,1400
    disable-dev-shm-usage
    disable-search-engine-choice-screen
  ]

  chrome_options_args << "headless=new" unless ENV.fetch("HEADLESS", nil) == "false"

  chrome_options = Selenium::WebDriver::Chrome::Options.new(args: chrome_options_args)
  chrome_options.add_preference("autofill.profile_enabled", false)
  chrome_options.add_preference("autofill.credit_card_enabled", false)
  chrome_options.add_preference("credentials_enable_service", false)
  chrome_options.add_preference("profile.password_manager_enabled", false)

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    clear_session_storage: true,
    clear_local_storage: true,
    options: chrome_options
  )
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :chrome_headless

  include Devise::Test::IntegrationHelpers
end
