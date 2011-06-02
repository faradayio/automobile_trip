module BrighterPlanet
  module AutomobileTrip
    module Characterization
      def self.included(base)
        base.characterize do
          has :date
          has :country
          has :make
          has :make_year
          has :make_model
          has :make_model_year
          has :make_model_year_variant
          has :size_class
          has :hybridity
          has :urbanity_estimate
          has :hybridity_multiplier
          has :fuel_efficiency
          has :speed
          has :city_speed
          has :highway_speed
          has :duration
          has :origin
          has :destination
          has :distance
          has :fuel_use
          has :automobile_fuel # don't call this fuel b/c then if you specify fuel.name in tests sniff will try to look it up in the fuels fixture, not automobile_fuels
          has :mapquest_api_key, :display => lambda { |key| "secret key" }
        end
      end
    end
  end
end
