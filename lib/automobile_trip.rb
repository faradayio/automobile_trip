require 'emitter'

module BrighterPlanet
  module AutomobileTrip
    extend BrighterPlanet::Emitter

    def self.automobile_trip_model
      if Object.const_defined? 'AutomobileTrip'
        ::AutomobileTrip
      elsif Object.const_defined? 'AutomobileTripRecord'
        AutomobileTripRecord
      else
        raise 'There is no automobile trip model'
      end
    end
  end
end