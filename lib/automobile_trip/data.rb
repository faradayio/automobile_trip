require 'data_miner'

module BrighterPlanet
  module AutomobileTrip
    module Data
      def self.included(base)
        base.data_miner do
          schema do
            float 'emission'
            float 'emission_factor'
            float  'fuel_use'
            string 'fuel_type_name'
          end

          process :run_data_miner_on_belongs_to_associations
        end
      end
    end
  end
end
