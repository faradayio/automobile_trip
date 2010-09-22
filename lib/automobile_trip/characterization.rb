module BrighterPlanet
  module AutomobileTrip
    module Characterization
      def self.included(base)
        base.characterize do
          has :fuel_use
          has :fuel_type
        end
      end
    end
  end
end
