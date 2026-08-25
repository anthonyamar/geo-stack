# frozen_string_literal: true

require "test_helper"

class StaticPages::Contact::FormComponentTest < ViewComponent::TestCase
  test "renders contact form fields and submit button" do
    message = StaticPages::Contact::Message.new(
      name: "Jane Doe",
      email: "jane@example.com",
      message: "Hello"
    )

    render_inline(StaticPages::Contact::FormComponent.new(contact_message: message))

    assert_selector "[data-component='static-pages-contact-form']"
    assert_selector "input[name='contact_message[name]'][value='Jane Doe']"
    assert_selector "input[name='contact_message[email]'][value='jane@example.com']"
    assert_selector "textarea[name='contact_message[message]']", text: "Hello"
    assert_button "Send message"
    assert_selector "#contact_form_submit"
  end
end
