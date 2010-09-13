require 'active_record'
require 'falls_back_on'
require 'automobile_trip'
require 'sniff'

class AutomobileTripRecord < ActiveRecord::Base
  include Sniff::Emitter
  include BrighterPlanet::AutomobileTrip

  belongs_to :fuel_type, :foreign_key => 'fuel_type_name'

  falls_back_on :emission_factor => 20.556.pounds_per_gallon.to(:kilograms_per_litre), # from footprint model gasoline car CO2e / gallon
                :fuel_use        => 57.0                                               # based on wikianswers average tank size of 15 gallons
end
