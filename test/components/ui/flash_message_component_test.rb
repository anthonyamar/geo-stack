# frozen_string_literal: true

require "test_helper"

class Ui::FlashMessageComponentTest < ViewComponent::TestCase
  test "renders the message with a button that dismisses the alert" do
    render_inline(Ui::FlashMessageComponent.new(type: "notice", message: "Saved"))

    assert_text "Saved"
    assert_selector "button[type='button'][data-action='click->flash-message#close:prevent']"
    assert_no_selector "a[href='#']"
  end
end
