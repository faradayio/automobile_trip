module BrighterPlanet
  module AutomobileTrip
    module Fallback
      def self.included(base)
        base.falls_back_on :hybridity_multiplier => 1.0,
      end
    end
  end
end
