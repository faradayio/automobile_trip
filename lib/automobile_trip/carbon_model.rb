require 'leap'
require 'conversions'

module BrighterPlanet
  module AutomobileTrip
    module CarbonModel
      def self.included(base)
        base.extend ::Leap::Subject
        base.decide :emission, :with => :characteristics do
          committee :emission do
            quorum 'from fuel consumed and emission factor' do
              16.0
            end
          end
        end
      end
    end
  end
end
