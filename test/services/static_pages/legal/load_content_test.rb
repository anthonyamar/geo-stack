# frozen_string_literal: true

require "test_helper"

class StaticPages::Legal::LoadContentTest < ActiveSupport::TestCase
  test "renders privacy policy markdown for english" do
    content = StaticPages::Legal::LoadContent.call(page: :privacy_policy, locale: :en)

    assert_match(/Privacy Policy/, content.html)
  end

  test "renders terms markdown for french" do
    content = StaticPages::Legal::LoadContent.call(page: :terms, locale: :fr)

    assert_match(/Conditions/, content.html)
  end
end
