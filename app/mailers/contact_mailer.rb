# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  def inquiry(contact_message)
    @contact_message = contact_message

    mail(
      to: ENV.fetch("WEBSITE_CONTACT_EMAIL"),
      reply_to: contact_message.email,
      subject: default_i18n_subject(name: contact_message.name)
    )
  end
end
