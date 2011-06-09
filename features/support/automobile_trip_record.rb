require 'active_record'
require 'falls_back_on'
require 'automobile_trip'
require 'sniff'

class AutomobileTripRecord < ActiveRecord::Base
  include Sniff::Emitter
  include BrighterPlanet::AutomobileTrip
end
