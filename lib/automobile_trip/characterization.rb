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
          has :urbanity
          has :hybridity_multiplier
          has :fuel_efficiency, :measures => Measurement::BigLengthPerVolume
          has :speed, :measures => Measurement::BigSpeed
          has :city_speed, :measures => Measurement::BigSpeed
          has :highway_speed, :measures => Measurement::BigSpeed
          has :duration, :measures => :time
          has :origin
          has :destination
          has :distance, :measures => Measurement::BigLength
          has :fuel_use, :measures => Measurement::Volume
          has :automobile_fuel # don't call this fuel b/c then if you specify fuel.name in tests sniff will try to look it up in the fuels fixture, not automobile_fuels
        end
      end
    end
  end
end
