module BrighterPlanet
  module AutomobileTrip
    module Fallback
      def self.included(base)
        base.falls_back_on :emission_factor => 20.556.pounds_per_gallon.to(:kilograms_per_litre), # from footprint model gasoline car CO2e / gallon
                           :fuel_use        => 57.0                                               # based on wikianswers average tank size of 15 gallons
      end
    end
  end
end
