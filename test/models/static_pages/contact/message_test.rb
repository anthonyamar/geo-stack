# frozen_string_literal: true

require "test_helper"

class StaticPages::Contact::MessageTest < ActiveSupport::TestCase
  test "is valid with required attributes" do
    message = StaticPages::Contact::Message.new(
      name: "Jane Doe",
      email: "jane@example.com",
      message: "Hello there"
    )

    assert_predicate message, :valid?
  end

  test "is invalid without required attributes" do
    message = StaticPages::Contact::Message.new

    assert_not message.valid?
    assert_includes message.errors.attribute_names, :name
    assert_includes message.errors.attribute_names, :email
    assert_includes message.errors.attribute_names, :message
  end

  test "is invalid with malformed email" do
    message = StaticPages::Contact::Message.new(
      name: "Jane Doe",
      email: "not-an-email",
      message: "Hello there"
    )

    assert_not message.valid?
    assert_includes message.errors.attribute_names, :email
  end
end
