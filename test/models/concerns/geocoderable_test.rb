# frozen_string_literal: true

require "test_helper"

class GeocoderableTest < ActiveSupport::TestCase
  setup do
    skip "Skipping geocoderable test - no model with geocoderable concern"
    # Replace with any model that has the geocoderable concern
    @record = build(:record_with_geocoder_data)
    @other_record = build(:other_record_with_geocoder_data)
  end

  test "save and save! should behave like always" do
    assert @record.save

    assert_equal @other_record, @other_record.save!
  end

  test "should fetch and store geocoder_data on save(!) if flagged" do
    # Works also with create, create!, update, update! as they call save behind the scenes.
    assert @record.geocoder_data.blank?
    assert @record.save(store_geocoder_data: true)
    assert @record.geocoder_data.present?

    assert @other_record.geocoder_data.blank?
    assert @other_record.save!(store_geocoder_data: true)
    assert @other_record.geocoder_data.present?
  end

  # rubocop:disable Style:OpenStructUse
  test "should output a deep OpenStruct object with geocoder_data" do
    assert @record.save(store_geocoder_data: true)
    assert @record.geocoder_object.is_a?(OpenStruct)
    assert_equal @record.geocoder_data["place_id"], @record.geocoder_object.place_id
    assert_equal @record.geocoder_data["address"]["city"], @record.geocoder_object.address.city
  end
  # rubocop:enable Style:OpenStructUse

  test "validates lonlat presence" do
    @record.lonlat = nil
    assert_raises ActiveRecord::RecordInvalid, "Validation failed : Lonlat must be filled" do
      @record.save!(store_geocoder_data: true)
    end
  end
end
