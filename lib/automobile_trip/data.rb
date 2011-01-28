module BrighterPlanet
  module AutomobileTrip
    module Data
      def self.included(base)
        base.data_miner do
          schema do
            date    'date'
            string  'make_name'
            string  'make_year_name'
            string  'make_model_name'
            string  'make_model_year_name'
            string  'make_model_year_variant_row_hash'
            string  'size_class_name'
            boolean 'hybridity'
            float   'urbanity'
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
            string  'fuel_type_code'
            string  'mapquest_api_key'
          end
          process :run_data_miner_on_belongs_to_associations
        end
      end
    end
  end
end
