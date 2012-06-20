module BrighterPlanet
  module AutomobileTrip
    module Characterization
      def self.included(base)
        base.characterize do
          has :make
          has :model
          has :year
          has :size_class
          has :automobile_fuel # can't call this 'fuel' or else sniff thinks it refers to Fuel not AutomobileFuel
          has :country
          has :date
          has :hybridity
          has :urbanity
          has :origin
          has :destination
          has :speed,                   :measures => Measurement::BigSpeed
          has :duration,                :measures => :time
          has :distance,                :measures => Measurement::BigLength
          has :fuel_efficiency_city,    :measures => Measurement::BigLengthPerVolume
          has :fuel_efficiency_highway, :measures => Measurement::BigLengthPerVolume
          has :fuel_efficiency,         :measures => Measurement::BigLengthPerVolume
          has :fuel_use,                :measures => Measurement::Volume
        end
      end
    end
  end
end
