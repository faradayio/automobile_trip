module BrighterPlanet
  module AutomobileTrip
    module Data
      def self.included(base)
        base.create_table do
          date    'date'
          string  'country_iso_3166_code'
          string  'make_name'
          string  'make_year_name'
          string  'make_model_name'
          string  'make_model_year_name'
          string  'make_model_year_variant_row_hash'
          string  'size_class_name'
          boolean 'hybridity'
          float   'urbanity_estimate'
          float   'hybridity_multiplier'
          float   'fuel_efficiency'
          float   'speed'
          float   'city_speed'
          float   'highway_speed'
          float   'duration'
          string  'origin'
          string  'destination'
          float   'distance'
          float   'fuel_use'
          string  'automobile_fuel_name'
        end
      end
    end
  end
end
