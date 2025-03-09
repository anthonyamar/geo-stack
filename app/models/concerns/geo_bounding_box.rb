# frozen_string_literal: true

module GeoBoundingBox
  extend ActiveSupport::Concern

  included do
    raise ArgumentError, "must have bounding_box column to include GeoBoundingBox" unless column_names.include?("bounding_box_geom")

    validates :lonlat, presence: true
  end

  delegate :contains?, to: :bounding_box_geom
end
