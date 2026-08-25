# frozen_string_literal: true

require "test_helper"

class Ui::ThemeToggleComponentTest < ViewComponent::TestCase
  test "renders system light and dark icon buttons" do
    render_inline(Ui::ThemeToggleComponent.new)

    assert_selector '[data-component="theme-toggle"][data-controller="theme"]'
    assert_selector 'button[data-theme-preference-param="system"] i.fa-computer'
    assert_selector 'button[data-theme-preference-param="light"] i.fa-sun'
    assert_selector 'button[data-theme-preference-param="dark"] i.fa-moon'
  end
end
