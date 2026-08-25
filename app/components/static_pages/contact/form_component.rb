# frozen_string_literal: true

class StaticPages::Contact::FormComponent < ApplicationComponent
  def initialize(contact_message:)
    @contact_message = contact_message
  end
end
