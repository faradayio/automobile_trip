
module BrighterPlanet
  module AutomobileTrip
    module CarbonModel
      def self.included(base)
        base.decide :emission, :with => :characteristics do
          committee :emission do # returns kg CO2e
            quorum 'from fuel use and emission factor', :needs => [:fuel_use, :emission_factor] do |characteristics|
              characteristics[:fuel_use] * characteristics[:emission_factor]
            end
            
            quorum 'default' do
              raise "The emission committee's default quorum should never be called"
            end
          end
          
          committee :emission_factor do # returns lbs CO2e / l
            quorum 'from fuel type', :needs => :fuel_type do |characteristics|
              characteristics[:fuel_type].emission_factor
            end
            
            quorum 'default' do
              base.fallback.emission_factor
            end
          end
          
          committee :fuel_use do # returns l
            quorum 'default' do
              base.fallback.fuel_use
            end
          end
        end
      end
    end
  end
end
