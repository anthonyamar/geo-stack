# frozen_string_literal: true

class StaticPages::Legal::LoadContent < ApplicationService
  Content = Data.define(:html)

  FILES = {
    privacy_policy: {
      en: Rails.root.join("config/legal/privacy_policy_en.md"),
      fr: Rails.root.join("config/legal/privacy_policy_fr.md")
    },
    terms: {
      en: Rails.root.join("config/legal/terms_en.md"),
      fr: Rails.root.join("config/legal/terms_fr.md")
    }
  }.freeze

  def initialize(page:, locale: I18n.locale)
    super()
    @page = page.to_sym
    @locale = locale.to_sym
  end

  def call
    Content.new(html: rendered_html)
  end

  private

  def rendered_html
    Kramdown::Document.new(markdown_with_hard_breaks).to_html
  end

  def markdown_with_hard_breaks
    markdown_source.gsub(/(?<!\n)\n(?!\n)/, "  \n")
  end

  def markdown_source
    File.read(content_path)
  end

  def content_path
    FILES.fetch(@page).fetch(@locale)
  end
end
