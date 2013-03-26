require 'emitter'

require 'automobile_trip/impact_model'
require 'automobile_trip/characterization'
require 'automobile_trip/data'
require 'automobile_trip/relationships'
require 'automobile_trip/summarization'
require 'mapquest_directions'

module BrighterPlanet
  module AutomobileTrip
    extend BrighterPlanet::Emitter
    scope 'The automobile trip emission estimate is the total anthropogenic emissions from fuel and air conditioning used by the automobile during the trip. It includes CO2 emissions from combustion of non-biogenic fuel, CH4 and N2O emissions from combustion of all fuel, and fugitive HFC emissions from air conditioning. For vehicles powered by grid electricity it includes the emissions from generating that electricity.'

    class << self
      attr_accessor :geocoder
    end
  end
end
