# frozen_string_literal: true

class ArticleWrapperComponent < ApplicationComponent
  def initialize(html:)
    @html = html
  end
end
