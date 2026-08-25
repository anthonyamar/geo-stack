# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home; end

  def contact
    @contact_message = StaticPages::Contact::Message.new(
      email: current_user&.email
    )
  end

  def create_contact
    @contact_message = StaticPages::Contact::Message.new(contact_message_params)

    if StaticPages::Contact::Send.call(contact_message: @contact_message)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to contact_path, notice: t(".success") }
      end
    else
      redirect_to contact_path, alert: t(".failure")
    end
  end

  def privacy_policy
    @content = StaticPages::Legal::LoadContent.call(page: :privacy_policy)
  end

  def terms
    @content = StaticPages::Legal::LoadContent.call(page: :terms)
  end

  private

  def contact_message_params
    params.expect(contact_message: %i[name email message])
  end
end
