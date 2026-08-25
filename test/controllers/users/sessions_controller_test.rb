# frozen_string_literal: true

require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    skip_unless_devise_route!(:new_user_session)
    @user = create(:user, :confirmed, password: "password123")
  end

  test "should get sign in page" do
    get new_user_session_path
    assert_response :success
  end

  test "should sign in with valid credentials" do
    post user_session_path, params: { user: { email: @user.email, password: "password123" } }
    assert_redirected_to root_path
    assert_equal @user.id, session["warden.user.user.key"][0][0]
  end

  test "should not sign in with invalid credentials" do
    post user_session_path, params: { user: { email: @user.email, password: "wrongpassword" } }
    assert_response :unprocessable_content
    assert_match(/Invalid email or password/i, response.body)
  end
end
