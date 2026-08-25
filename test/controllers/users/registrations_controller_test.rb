# frozen_string_literal: true

require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    skip_unless_devise_route!(:new_user_registration)
  end

  test "should get sign up page" do
    get new_user_registration_path
    assert_response :success
  end

  test "should sign up with valid data" do
    post user_registration_path, params: {
      user: {
        email: "test@example.com", password: "password123", password_confirmation: "password123"
      }
    }
    assert_redirected_to root_path
  end

  test "should not sign up with invalid data" do
    post user_registration_path, params: { user: { email: "", password: "short", password_confirmation: "short" } }
    assert_response :unprocessable_content
  end

  context "user registration edit" do
    setup do
      skip_unless_devise_route!(:edit_user_registration)
      @user = create(:user, :confirmed, password: "password123")
      sign_in @user
    end

    should "should get edit profile page" do
      get edit_user_registration_path
      assert_response :success
    end

    should "should update profile with valid data" do
      put user_registration_path, params: { user: { email: "newemail@example.com", current_password: "password123" } }
      assert_redirected_to root_path
      assert_equal I18n.t("devise.registrations.updated"), flash[:notice]
      assert_equal "newemail@example.com", @user.reload.email
    end

    should "should not update profile with invalid data" do
      sign_in @user
      patch user_registration_path, params: {
        user: {
          email: "",
          current_password: "wrong_password"
        }
      }

      assert_response :unprocessable_content
    end

    should "should delete account" do
      delete user_registration_path
      assert_redirected_to root_path
      assert_match I18n.t("devise.registrations.destroyed"), flash[:notice]
      assert_nil User.find_by(email: @user.email)
    end
  end
end
