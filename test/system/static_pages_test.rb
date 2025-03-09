# frozen_string_literal: true

require 'application_system_test_case'

class StaticPagesTest < ApplicationSystemTestCase
  test "should get home page" do
    visit root_path
    assert_selector 'h1', text: 'Start your coding journey today.'
  end
end
