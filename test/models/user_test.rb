# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:email)
  should validate_length_of(:email).is_at_most(255)
  should allow_value("valid@example.com").for(:email)
  should_not allow_value("invalid_email").for(:email)
  should validate_uniqueness_of(:email).case_insensitive

  should validate_presence_of(:password)
  should validate_length_of(:password).is_at_least(6).is_at_most(128)

  context "authentification" do
    should "authenticate valid user" do
      user = create(:user, password: "password123")
      assert User.find_for_authentication(email: user.email).try(:valid_password?, "password123")
    end

    should "not authenticate invalid user" do
      user = create(:user, password: "password123")
      assert_not User.find_for_authentication(email: user.email).try(:valid_password?, "wrongpassword")
    end
  end
end
