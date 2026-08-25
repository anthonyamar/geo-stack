# frozen_string_literal: true

# Ensure config/locales wins over app/components/**/*.yml in the global I18n backend.
Rails.application.config.after_initialize do
  locale_paths = Rails.root.glob("config/locales/**/*.{rb,yml}").map do |path|
    File.expand_path(path, Rails.root)
  end.uniq

  load_path = I18n.config.load_path.map { |path| File.expand_path(path, Rails.root) }
  load_path.reject! { |path| locale_paths.include?(path) }
  load_path.concat(locale_paths)

  I18n.config.load_path = load_path
  I18n.reload!
end
