# frozen_string_literal: true

username = ENV["MISSION_CONTROL_HTTP_BASIC_USERNAME"]
password = ENV["MISSION_CONTROL_HTTP_BASIC_PASSWORD"]

Rails.application.configure do
  config.mission_control.jobs.http_basic_auth_user = username if username.present?
  config.mission_control.jobs.http_basic_auth_password = password if password.present?
end
