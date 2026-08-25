# frozen_string_literal: true

return if ENV["BUGSNAG_API_KEY"].blank? || Rails.env.local?

Bugsnag.configure do |config|
  config.api_key = ENV.fetch("BUGSNAG_API_KEY")
  config.release_stage = Rails.env
end
