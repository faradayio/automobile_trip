module BrighterPlanet
  module AutomobileTrip
    module Data
      def self.included(base)
        col :date, :type => :date   
        col :country_iso_3166_code 
        col :make_name 
        col :make_year_name 
        col :make_model_name 
        col :make_model_year_name 
        col :make_model_year_variant_row_hash 
        col :size_class_name 
        col :hybridity, :type => :boolean
        col :urbanity, :type => :float  
        col :hybridity_multiplier, :type => :float  
        col :fuel_efficiency, :type => :float  
        col :speed, :type => :float  
        col :city_speed, :type => :float  
        col :highway_speed, :type => :float  
        col :duration, :type => :float  
        col :origin 
        col :destination 
        col :distance, :type => :float  
        col :fuel_use, :type => :float  
        col :automobile_fuel_name 
      end
    end
  end
end
