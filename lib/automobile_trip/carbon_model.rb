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
            quorum 'from fuel cost and fuel price' do
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
            
            quorum 'from fuel type' do
              
            end
          end
          
          committee :distance do
            quorum 'from duration and speed' do
              duration * speed
            end
          end
          
          commitee :average_fuel_efficiency do
            quorum 'from variant' do # variant includes make, year, and model
            end
            
            quorum 'from model' do # model includes make and year
            end
            
            quorum 'from year' do # year includes make
            end
            
            quorum 'from make' do
            end
          end
          
          committee :fuel_type do
            quorum 'from variant' do
            end
            
            quorum 'from model' do
            end
            
            quorum 'from make' do
            end
            
            quorum 'default' do
              AutomobileTrip.fallback.fuel_type
            end
          end
        end
      end
    end
  end
end
