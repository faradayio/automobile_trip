module BrighterPlanet
  module AutomobileTrip
    module Relationships
      def self.included(target)
        target.belongs_to :fuel_type, :foreign_key => 'fuel_type_name'
      end
    end
  end
end
