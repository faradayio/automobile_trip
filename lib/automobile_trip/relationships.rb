module BrighterPlanet
  module AutomobileTrip
    module Relationships
      def self.included(target)
        target.belongs_to :make,       :class_name => 'AutomobileMake'
        target.belongs_to :model,      :class_name => 'AutomobileModel'
        target.belongs_to :year,       :class_name => 'AutomobileYear',     :foreign_key => 'year'
        target.belongs_to :size_class, :class_name => 'AutomobileSizeClass'
        target.belongs_to :automobile_fuel
        target.belongs_to :country
      end
    end
  end
end
