# frozen_string_literal: true

module AcceptLanguage
  module_function

  def preferred?(header, locale:)
    ranked_locales(header).first == locale.to_s.downcase
  end

  def ranked_locales(header)
    entries = header.to_s.split(",").filter_map do |part|
      language, quality = part.strip.split(";q=", 2)
      tag = language.to_s.split("-").first.downcase
      next if tag.blank?

      [tag, (quality || "1").to_f]
    end

    entries.sort_by { |_, quality| -quality }.map(&:first)
  end
end
