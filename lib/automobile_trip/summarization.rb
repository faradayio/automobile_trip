require 'summary_judgement'

module BrighterPlanet
  module AutomobileTrip
    module Summarization
      def self.included(base)
        base.extend SummaryJudgement
        base.summarize do |has|
          has.identity 'automobile trip'
        end
      end
    end
  end
end
