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
            #, :needs => [:fuel_consumed, :emission_factor] do |characteristics|
#              characteristics[:fuel_consumed] * characteristics[:emission_factor]
              16
            end
            
            quorum 'default' do
              raise "The emission committee's default quorum should never be called"
            end
          end
          
          committee :emission_factor do
            quorum 'from fuel type', :needs => :fuel_type do |characteristics|
              characteristics[:fuel_type].emission_factor
            end
            
            quorum 'default' do
              AutomobileTrip.fallback.emission_factor
            end
          end
          
          committee :fuel_consumed do
            quorum 'from fuel cost and fuel price'
              fuel_cost / fuel_price
            end
            
            quorum 'from distance and fuel efficiency', :needs => [:distance, :average_fuel_efficiency] do |characteristics|
              characteristics[:distance] / characteristics[:average_fuel_efficiency]
            end
          end
          
          committee :fuel_price do
            # quorum 'from location'
            #   
            # end
            
            quorum 'from fuel type'
              
            end
          end
          
          committee :distance do
            quorum 'from duration and speed'
              duration * speed
            end
          end
          
          commitee :average_fuel_efficiency do
            quorum 'from variant' # variant includes make, year, and model
            end
            
            quorum 'from model' # model includes make and year
            end
            
            quorum 'from year' # year includes make
            end
            
            quorum 'from make'
            end
          end
          
          committee :fuel_type do
            quorum 'from variant'
            end
            
            quorum 'from model'
            end
            
            quorum 'from make'
            end
            
            quorum 'default'
              AutomobileTrip.fallback.fuel_type
            end
          end
        end
      end
    end
  end
end
