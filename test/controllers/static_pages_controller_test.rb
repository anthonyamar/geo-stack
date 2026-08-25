# frozen_string_literal: true

require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  context "#home" do
    should "respond successfully" do
      get root_path

      assert_response :success
    end
  end

  context "#contact" do
    setup do
      @previous_contact_email = ENV.fetch("WEBSITE_CONTACT_EMAIL", nil)
      ENV["WEBSITE_CONTACT_EMAIL"] = "team@#{GeoStack::DOMAIN}"
    end

    teardown do
      ENV["WEBSITE_CONTACT_EMAIL"] = @previous_contact_email
    end

    should "respond successfully" do
      get contact_path

      assert_response :success
      assert_match(/data-component="static-pages-contact-form"/, response.body)
    end

    should "respond successfully in French" do
      get contact_path(locale: :fr)

      assert_response :success
      assert_match(/Contact/, response.body)
    end

    should "pre-fill email for signed-in users" do
      sign_in create(:user, :confirmed, email: "jane@example.com")

      get contact_path

      assert_match(/name="contact_message\[email\]"/, response.body)
      assert_match(/value="jane@example.com"/, response.body)
    end

    should "send contact message via turbo stream" do
      assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
        post contact_path,
             params: {
               contact_message: {
                 name: "Jane Doe",
                 email: "jane@example.com",
                 message: "Hello from the contact page."
               }
             },
             as: :turbo_stream
      end

      assert_response :success
      assert_match(/alert-success/, response.body)
    end

    should "redirect with alert when message is invalid" do
      post contact_path,
           params: { contact_message: { name: "", email: "", message: "" } }

      assert_redirected_to contact_path
      assert_equal I18n.t("static_pages.create_contact.failure"), flash[:alert]
    end
  end

  context "#privacy_policy" do
    should "respond successfully" do
      get privacy_policy_path

      assert_response :success
      assert_match(/Privacy Policy/, response.body)
    end

    should "respond successfully in French" do
      get privacy_policy_path(locale: :fr)

      assert_response :success
    end
  end

  context "#terms" do
    should "respond successfully" do
      get terms_path

      assert_response :success
      assert_match(/Terms of Use/, response.body)
    end
  end
end
