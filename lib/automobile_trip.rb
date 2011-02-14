require 'emitter'

module BrighterPlanet
  module AutomobileTrip
    extend BrighterPlanet::Emitter
    scope 'The automobile trip emission estimate includes CO2 emissions from non-biogenic fuel use, CH4 and N2O emissions from all fuel use, and fugitive HFC emissions from air conditioning.'
  end
end
