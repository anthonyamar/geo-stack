# frozen_string_literal: true

require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  context "#home" do
    should "respond successfully" do
      get root_path

      assert_response :success
    end

    should "apply a DaisyUI theme and base background on the document" do
      get root_path

      assert_match(/<html[^>]*data-theme="user-theme"/, response.body)
      assert_match(/<html[^>]*class="[^"]*bg-base/, response.body)
      assert_match(/<body[^>]*class="[^"]*bg-base/, response.body)
      assert_match(/<header[^>]*class="[^"]*bg-base/, response.body)
    end

    should "keep only auth links in the header" do
      get root_path
      header = response.body[%r{<header[\s\S]*?</header>}].to_s

      assert_match I18n.t("layouts.header.sign_in"), header
      assert_match I18n.t("layouts.header.sign_up"), header
      assert_no_match I18n.t("nav.contact"), header
      assert_no_match I18n.t("nav.locale.en"), header
      assert_no_match I18n.t("nav.locale.fr"), header
    end

    should "keep contact and locale switcher in the footer without a made-with-love line" do
      get root_path
      footer = response.body[%r{<footer[\s\S]*?</footer>}].to_s

      assert_match I18n.t("nav.contact"), footer
      assert_match I18n.t("nav.locale.en"), footer
      assert_match I18n.t("nav.locale.fr"), footer
      assert_no_match(/Made with love/, footer)
      assert_no_match(/Fait avec amour/, footer)
    end

    should "render a simple hero without decorative clip-path blobs" do
      get root_path

      assert_match(/<h1/, response.body)
      assert_no_match(/clip-path/, response.body)
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

    should "render dismissible flash above the overlapping header" do
      post contact_path,
           params: { contact_message: { name: "", email: "", message: "" } }
      follow_redirect!

      assert_match(/data-controller="flash-message"[^>]*z-\[60\]/, response.body)
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
