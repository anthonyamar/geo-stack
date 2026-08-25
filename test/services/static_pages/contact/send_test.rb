# frozen_string_literal: true

require "test_helper"

class StaticPages::Contact::SendTest < ActiveSupport::TestCase
  setup do
    @previous_contact_email = ENV.fetch("WEBSITE_CONTACT_EMAIL", nil)
    ENV["WEBSITE_CONTACT_EMAIL"] = "team@#{GeoStack::DOMAIN}"
  end

  teardown do
    ENV["WEBSITE_CONTACT_EMAIL"] = @previous_contact_email
  end

  test "returns true and delivers email when message is valid" do
    message = StaticPages::Contact::Message.new(
      name: "Jane Doe",
      email: "jane@example.com",
      message: "I have a question."
    )

    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      assert StaticPages::Contact::Send.call(contact_message: message)
    end

    delivered = ActionMailer::Base.deliveries.last

    assert_equal ["team@#{GeoStack::DOMAIN}"], delivered.to
    assert_equal "jane@example.com", delivered.reply_to.first
    assert_includes delivered.subject, "Jane Doe"
  end

  test "returns false when message is invalid" do
    message = StaticPages::Contact::Message.new

    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      assert_not StaticPages::Contact::Send.call(contact_message: message)
    end
  end

  test "returns false when delivery fails" do
    message = StaticPages::Contact::Message.new(
      name: "Jane Doe",
      email: "jane@example.com",
      message: "Hello"
    )
    mail = mock
    mail.stubs(:deliver_now).raises(StandardError, "delivery failed")
    ContactMailer.stubs(:inquiry).returns(mail)

    assert_not StaticPages::Contact::Send.call(contact_message: message)
  end
end
