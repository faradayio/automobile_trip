module BrighterPlanet
  module AutomobileTrip
    module Fallback
      def self.included(base)
        base.falls_back_on :urbanity_estimate => 0.43,
                           :city_speed => 19.9.miles.to(:kilometres),
                           :highway_speed => 57.1.miles.to(:kilometres),
                           :hybridity_multiplier => 1.0,
                           :fuel_efficiency => 20.182.miles_per_gallon.to(:kilometres_per_litre),
                           :distance => 10.15.miles.to(:kilometres)
      end
    end
  end
end
