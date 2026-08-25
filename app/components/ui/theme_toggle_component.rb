# frozen_string_literal: true

class Ui::ThemeToggleComponent < ApplicationComponent
  OPTIONS = [
    { preference: "system", icon: "fa-solid fa-computer" },
    { preference: "light", icon: "fa-solid fa-sun" },
    { preference: "dark", icon: "fa-solid fa-moon" }
  ].freeze

  def options
    OPTIONS
  end
end
