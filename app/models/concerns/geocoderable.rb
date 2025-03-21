# frozen_string_literal: true

module Geocoderable
  extend ActiveSupport::Concern

  included do
    attr_accessor :store_geocoder_data

    validates :lonlat, presence: true
  end

  def save(*args, **options)
    self.store_geocoder_data = options.delete(:store_geocoder_data) if options.key?(:store_geocoder_data)
    result = super
    ensure_geocoder_data if store_geocoder_data && persisted?
    result
  end

  def save!(*args, **options)
    self.store_geocoder_data = options.delete(:store_geocoder_data) if options.key?(:store_geocoder_data)
    super
    ensure_geocoder_data if store_geocoder_data && persisted?
    self
  end

  def geocoder_object
    return @struct if defined?(@struct)

    @struct = if geocoder_data.present?
      deep_open_struct(geocoder_data.deep_symbolize_keys)
    elsif store_geocoder_data
      deep_open_struct(fetch_and_store_geocoder_data.deep_symbolize_keys)
    else
      {}
    end

    @struct
  end

  private

  def fetch_and_store_geocoder_data
    result = Geocoder.search(to_coordinates).first
    return {} if result.blank?

    geocoder_info = result.data.deep_symbolize_keys

    # rubocop:disable Rails/SkipsModelValidations
    if new_record?
      self.geocoder_data = geocoder_info
      save!
    else
      update_column(:geocoder_data, geocoder_info)
    end
    # rubocop:enable Rails/SkipsModelValidations

    geocoder_info
  end

  def ensure_geocoder_data
    return if geocoder_data.present?

    fetch_and_store_geocoder_data
  end

  # rubocop:disable Style/OpenStructUse
  def deep_open_struct(obj)
    case obj
    when Hash
      OpenStruct.new(obj.transform_values { |v| deep_open_struct(v) })
    when Array
      obj.map { |v| deep_open_struct(v) }
    else
      obj
    end
  end
  # rubocop:enable Style/OpenStructUse
end
