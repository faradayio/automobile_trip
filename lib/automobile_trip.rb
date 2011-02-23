require 'emitter'

module BrighterPlanet
  module AutomobileTrip
    extend BrighterPlanet::Emitter
    scope 'The automobile trip emission estimate is the total anthropogenic emissions from fuel and air conditioning used by the automobile during the trip. It includes CO2 emissions from combustion of non-biogenic fuel, CH4 and N2O emissions from combustion of all fuel, and fugitive HFC emissions from air conditioning.'
  end
end
