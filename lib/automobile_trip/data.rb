module BrighterPlanet
  module AutomobileTrip
    module Data
      def self.included(base)
        base.col :make_name
        base.col :model_name
        base.col :year_name,       :type => :integer
        base.col :size_class_name
        base.col :automobile_fuel_name
        base.col :country_iso_3166_code
        base.col :origin_country_iso_3166_code
        base.col :destination_country_iso_3166_code
        base.col :date,            :type => :date
        base.col :hybridity,       :type => :boolean
        base.col :urbanity,        :type => :float
        base.col :speed,           :type => :float
        base.col :duration,        :type => :float
        base.col :origin
        base.col :destination
        base.col :distance,        :type => :float
        base.col :fuel_efficiency, :type => :float
        base.col :fuel_use,        :type => :float
      end
    end
  end
end
