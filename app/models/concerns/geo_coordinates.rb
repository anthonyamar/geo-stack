# frozen_string_literal: true

module GeoCoordinates
  extend ActiveSupport::Concern

  included do
    raise ArgumentError, "must have a lonlat column to include GeoCoordinates" unless column_names.include?("lonlat")

    validates :original_longitude,
              presence: true,
              numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
    validates :original_latitude,
              presence: true,
              numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
    validates :lonlat, presence: true

    reverse_geocoded_by :latitude, :longitude
  end

  class_methods do
    def nearby(other_point, radius_in_km: 10)
      radius_in_meters = radius_in_km * 1000

      where("ST_DWithin(lonlat, ?, ?)", other_point, radius_in_meters)
    end
  end

  # same output as .to_coordinates from Geocoder
  delegate :coordinates, to: :lonlat
  delegate :longitude, to: :lonlat
  delegate :latitude, to: :lonlat

  def nearby?(other_point, radius_in_km: 10)
    return false unless lonlat && other_point

    radius_in_meters = radius_in_km * 1000

    self.class.where("ST_DWithin(lonlat, ?, ?)", other_point, radius_in_meters).exists?(id)
  end
end
