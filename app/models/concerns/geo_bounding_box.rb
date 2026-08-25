# frozen_string_literal: true

module GeoBoundingBox
  extend ActiveSupport::Concern

  included do
    unless column_names.include?("bounding_box_geom")
      raise ArgumentError, "must have bounding_box_geom column to include GeoBoundingBox"
    end

    validates :lonlat, presence: true
  end

  delegate :contains?, to: :bounding_box_geom
end
