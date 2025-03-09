# frozen_string_literal: true

class ApplicationService
  delegate :transaction, to: ApplicationRecord

  def self.call(...)
    new(...).call
  end

  def self.call!(...)
    new(...).call!
  end

  private

  def save_records(&)
    transaction(&)
    true
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed
    false
  end
end
