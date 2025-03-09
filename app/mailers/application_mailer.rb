# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "humans@example.com"
  layout "mailer"
end
