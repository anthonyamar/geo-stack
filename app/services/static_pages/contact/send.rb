# frozen_string_literal: true

class StaticPages::Contact::Send < ApplicationService
  def initialize(contact_message:)
    super()
    @contact_message = contact_message
  end

  def call
    return false unless @contact_message.valid?

    ContactMailer.inquiry(@contact_message).deliver_now
    true
  rescue StandardError => e
    Rails.logger.error("[StaticPages::Contact::Send] #{e.class}: #{e.message}")
    false
  end
end
