# frozen_string_literal: true

require "test_helper"

class Users::PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    skip_unless_devise_route!(:new_user_password)
    @user = create(:user, :confirmed, email: "test@example.com")
  end

  test "should get new password page" do
    get new_user_password_path
    assert_response :success
  end

  test "should send reset password instructions with valid email" do
    post user_password_path, params: { user: { email: @user.email } }
    assert_redirected_to new_user_session_path
    assert_match I18n.t("devise.passwords.send_paranoid_instructions"), flash[:notice].to_s
  end

  test "should not send reset instructions with invalid email" do
    post user_password_path, params: { user: { email: "wrong@example.com" } }
    assert_response :redirect
  end
end
