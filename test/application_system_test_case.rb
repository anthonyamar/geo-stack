# frozen_string_literal: true

ENV['TEST_TYPE'] = 'system'
require "test_helper"

Capybara.register_driver :chrome_headless do |app|
  chrome_options_args = %w[
    disable-gpu
    no-sandbox
    window-size=1400,1400
    disable-dev-shm-usage
    disable-search-engine-choice-screen
  ]

  chrome_options_args << 'headless=new' unless ENV.fetch('HEADLESS', nil) == 'false'

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    clear_session_storage: true,
    clear_local_storage: true,
    options: Selenium::WebDriver::Chrome::Options.new(args: chrome_options_args)
  )
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :chrome_headless
end
