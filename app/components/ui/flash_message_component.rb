# frozen_string_literal: true

class Ui::FlashMessageComponent < ViewComponent::Base
  attr_reader :type, :message

  def initialize(type:, message:)
    super
    @type = type
    @message = message
  end

  private

  def color_classes
    case type.to_s
    when "success"
      'bg-green-100 border-green-400 text-green-700'
    when "error" || "danger"
      'bg-red-100 border-red-400 text-red-700'
    when "warning" || "alert"
      'bg-yellow-100 border-yellow-400 text-yellow-700'
    when "notice" || "info"
      'bg-sky-100 border-sky-400 text-blue-700'
    else
      'bg-gray-100 border-gray-400 text-gray-700'
    end
  end
end
