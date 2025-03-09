# frozen_string_literal: true

class Ui::BreadcrumbsComponent < ViewComponent::Base
  attr_reader :links, :classes

  def initialize(links, classes: "")
    super
    # Array of hashes like { link: "/path/", text: "My link" }
    @links = links
    @classes = classes
  end
end
