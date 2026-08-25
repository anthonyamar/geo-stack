# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: GeoStack::MAILER_FROM
  layout "mailer"
end
