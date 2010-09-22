module BrighterPlanet
  module AutomobileTrip
    module Summarization
      def self.included(base)
        base.summarize do |has|
          has.identity 'automobile trip'
        end
      end
    end
  end
end
