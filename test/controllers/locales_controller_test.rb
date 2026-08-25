# frozen_string_literal: true

require "test_helper"

class LocalesControllerTest < ActionDispatch::IntegrationTest
  test "switching to french stores session and redirects to localized path" do
    get locale_path(locale: "fr", return_to: contact_path)

    assert_redirected_to "/fr/contact"
    assert_equal "fr", session[:locale]
  end

  test "switching to english removes french prefix from path" do
    get locale_path(locale: "fr", return_to: contact_path)
    follow_redirect!

    get locale_path(locale: "en", return_to: "/fr/contact")

    assert_redirected_to "/contact"
    assert_equal "en", session[:locale]
  end

  test "redirects french browsers to french homepage on first visit" do
    get "/", headers: { "Accept-Language" => "fr-FR,fr;q=0.9" }

    assert_redirected_to "/fr"
  end

  test "does not redirect when locale session is present" do
    get locale_path(locale: "en", return_to: root_path)
    follow_redirect!

    get root_path, headers: { "Accept-Language" => "fr-FR,fr;q=0.9" }

    assert_response :success
  end

  test "rejects external return_to urls" do
    get locale_path(locale: "fr", return_to: "//evil.com/phish")

    assert_redirected_to "/fr"
  end
end
