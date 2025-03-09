# frozen_string_literal: true

require "test_helper"

class GeoCoordinatesTest < ActiveSupport::TestCase
  # let(:instance) { FactoryBot.build(:dive_site) }
  # let(:nearby_10km) { FactoryBot.build(:dive_site, :nearby_10km) }
  # let(:nearby_20km) { FactoryBot.build(:dive_site, :nearby_20km) }

  # describe 'validations' do
  #   it 'validates presence of latitude and longitude' do
  #     instance.original_latitude = nil
  #     instance.original_longitude = nil
  #     expect(instance).to_not be_valid
  #     expect(instance.errors[:original_latitude]).to include("must be filled")
  #     expect(instance.errors[:original_longitude]).to include("must be filled")
  #   end
  # end

  # describe '#longitude' do
  #   it 'returns longitude from lonlat' do
  #     expect(instance.longitude).to eq(45.0)
  #   end
  # end

  # describe '#latitude' do
  #   it 'returns latitude from lonlat' do
  #     expect(instance.latitude).to eq(90.0)
  #   end
  # end

  # describe '#coordinates' do
  #   it 'returns coordinates [lon, lat] from lonlat' do
  #     expect(instance.coordinates).to eq([45.0, 90.0])
  #   end
  # end

  # describe '#nearby?' do
  #   it 'raise ArgumentError if lonlat is nil' do
  #     nearby_10km.lonlat = nil
  #     expect { instance.nearby?(nearby_10km) }.to raise_error(ArgumentError)
  #   end

  #   it 'raise ArgumentError if other_point is nil' do
  #     expect { instance.nearby?(nil) }.to raise_error(ArgumentError)
  #   end

  #   it 'returns true if it is 10km around ' do
  #     expect(instance.nearby?(nearby_10km)).to be_truthy
  #   end

  #   it 'returns false if not nearby' do
  #     expect(instance.nearby?(nearby_20km)).to be_falsey
  #   end

  #   it 'works with a different radius_in_km' do
  #     expect(instance.nearby?(nearby_20km, radius_in_km: 20)).to be_truthy
  #   end
  # end
end
