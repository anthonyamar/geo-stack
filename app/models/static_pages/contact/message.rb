# frozen_string_literal: true

class StaticPages::Contact::Message
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :name, :string
  attribute :email, :string
  attribute :message, :string

  validates :name, :email, :message, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.model_name
    ActiveModel::Name.new(self, nil, "ContactMessage")
  end
end
