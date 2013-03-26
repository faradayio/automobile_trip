require 'automobile_trip'

class AutomobileTripRecord < ActiveRecord::Base
  include BrighterPlanet::Emitter
  include BrighterPlanet::AutomobileTrip
end

require 'geocoder'
class GeocoderWrapper
  def geocode(input)
    if res = ::Geocoder.search(input).first
      {
        latitude:  res.coordinates[0],
        longitude: res.coordinates[1],
      }
    end
  end
end

BrighterPlanet::AutomobileTrip.geocoder = GeocoderWrapper.new
