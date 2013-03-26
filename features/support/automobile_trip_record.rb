require 'automobile_trip'

class AutomobileTripRecord < ActiveRecord::Base
  include BrighterPlanet::Emitter
  include BrighterPlanet::AutomobileTrip
end
