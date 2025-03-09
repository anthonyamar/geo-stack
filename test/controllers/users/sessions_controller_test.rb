# frozen_string_literal: true

require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
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
    msg = "Email et/ou mot de passe incorrect(s)."
    assert_match msg, response.body
  end
end
