module BrighterPlanet
  module AutomobileTrip
    module Characterization
      def self.included(base)
        base.characterize do
          has :date
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
          has :fuel
          has :mapquest_api_key, :display => lambda { |key| "secret key" }
        end
      end
    end
  end
end
