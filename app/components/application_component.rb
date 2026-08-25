# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  def current_user_from_request
    helpers.current_user
  rescue Devise::MissingWarden
    nil
  end

  def user_signed_in_from_request?
    helpers.user_signed_in?
  rescue Devise::MissingWarden
    false
  end
end
