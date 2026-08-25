# frozen_string_literal: true

class Ui::PaginationComponent < ApplicationComponent
  attr_reader :pagy

  def initialize(pagy:, force_render: false, turbo_frame: nil)
    @pagy = pagy
    @force_render = force_render
    @turbo_frame = turbo_frame
  end

  def render?
    @force_render || pagy.pages > 1
  end

  # Pagy 43: helpers are instance methods on @pagy (page_url, series, etc.)
  def pagy_tailwind_nav(pagy) # rubocop:disable Metrics/MethodLength
    html = +'<nav class="flex items-center justify-between mt-6">'
    html << '<div class="flex-1 flex items-center justify-between">'

    if pagy.previous
      html << link_to(
        t_previous,
        pagy.page_url(:previous),
        class: "py-2 px-4 bg-base-200 text-base-content rounded hover:bg-base-300 hover:no-underline",
        **turbo_frame_link_options
      )
    else
      html << '<span class="py-2 px-4 text-base-content/40 rounded">'
      html << t_previous
      html << "</span>"
    end

    html << '<div class="hidden md:flex items-center space-x-2">'
    pagy.send(:series).each do |item|
      case item
      when String
        html << %(<span class="py-2 px-4 bg-primary text-primary-content rounded">#{item}</span>)
      when Integer
        html << link_to(
          item,
          pagy.page_url(item),
          class: "py-2 px-4 bg-base-300 rounded hover:bg-primary hover:text-primary-content hover:no-underline",
          **turbo_frame_link_options
        )
      when :gap
        html << %(<span class="py-2 px-4 text-base-content/50">...</span>)
      end
    end
    html << "</div>"

    if pagy.next
      html << link_to(
        t_next, pagy.page_url(:next),
        class: "py-2 px-4 bg-base-300 text-base-content rounded hover:bg-base-200 ml-2 hover:no-underline",
        **turbo_frame_link_options
      )
    else
      html << '<span class="py-2 px-4 text-base-content/40 rounded ml-2">'
      html << t_next
      html << "</span>"
    end

    html << "</div>"
    html << "</nav>"
    html.html_safe # rubocop:disable Rails/OutputSafety
  end

  private

  def t_previous
    t(".previous")
  end

  def t_next
    t(".next")
  end

  def turbo_frame_link_options
    return {} if @turbo_frame.blank?

    { data: { turbo_frame: @turbo_frame } }
  end
end
