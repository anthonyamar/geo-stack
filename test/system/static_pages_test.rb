# frozen_string_literal: true

require "application_system_test_case"

class StaticPagesTest < ApplicationSystemTestCase
  test "should get home page" do
    visit root_path

    assert_selector "h1", text: /coding/
  end

  test "footer links are clickable" do
    visit root_path

    within "footer" do
      click_link I18n.t("nav.contact")
    end
    assert_current_path contact_path
  end
end
