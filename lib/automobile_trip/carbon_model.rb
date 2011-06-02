# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

require File.expand_path('../../vendor/plugin/mapquest/lib/mapquest_directions', File.dirname(__FILE__))
require 'geokit'

## Automobile trip carbon model
# This model is used by [Brighter Planet](http://brighterplanet.com)'s carbon emission [web service](http://carbon.brighterplanet.com) to estimate the **greenhouse gas emissions of an automobile trip**.
#
##### Timeframe and activity period
# The model estimates the emissions that occur during a particular `timeframe`. To do this it needs to know the `date` on which the trip occurred. For example, if the `timeframe` is January 2010, a trip that occurred on January 5, 2010 will have emissions but a trip that occurred on February 1, 2010 will not.
#
##### Calculations
# The final estimate is the result of the **calculations** detailed below. These calculations are performed in reverse order, starting with the last calculation listed and finishing with the `emission` calculation. Each calculation is named according to the value it returns.
#
##### Methods
# To accomodate varying client input, each calculation may have one or more **methods**. These are listed under each calculation in order from most to least preferred. Each method is named according to the values it requires. If any of these values is not available the method will be ignored. If all the methods for a calculation are ignored, the calculation will not return a value. "Default" methods do not require any values, and so a calculation with a default method will always return a value.
#
##### Standard compliance
# Each method lists any established calculation standards with which it **complies**. When compliance with a standard is requested, all methods that do not comply with that standard are ignored. This means that any values a particular method requires will have been calculated using a compliant method, because those are the only methods available. If any value did not have a compliant method in its calculation then it would be undefined, and the current method would have been ignored.
#
##### Collaboration
# Contributions to this carbon model are actively encouraged and warmly welcomed. This library includes a comprehensive test suite to ensure that your changes do not cause regressions. All changes should include test coverage for new functionality. Please see [sniff](http://github.com/brighterplanet/sniff#readme), our emitter testing framework, for more information.
module BrighterPlanet
  module AutomobileTrip
    module CarbonModel
      def self.included(base)
        base.decide :emission, :with => :characteristics do
          ### Emission calculation
          # Returns the `emission` estimate (*kg CO<sub>2</sub>e*).
          committee :emission do
            #### Emission from CO<sub>2</sub> emission, CH<sub>4</sub> emission, N<sub>2</sub>O emission, and HFC emission
            quorum 'from co2 emission, ch4 emission, n2o emission, and hfc emission',
              :needs => [:co2_emission, :ch4_emission, :n2o_emission, :hfc_emission],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Sums the non-biogenic emissions to give *kg CO<sub>2</sub>e*.
                characteristics[:co2_emission] + characteristics[:ch4_emission] + characteristics[:n2o_emission] + characteristics[:hfc_emission]
            end
          end
          
          ### CO<sub>2</sub> emission calculation
          # Returns the `co2 emission` (*kg*).
          committee :co2_emission do
            #### CO<sub>2</sub> emission from fuel use, CO<sub>2</sub> emission factor, date, and timeframe
            quorum 'from fuel use, co2 emission factor, date, and timeframe',
              :needs => [:fuel_use, :co2_emission_factor, :date],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                # Checks whether the trip `date` falls within the `timeframe`.
                date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
                if timeframe.include? date
                  # Multiplies `fuel use` (*l*) by the `co2 emission factor` (*kg / l*) to give *kg*.
                  characteristics[:fuel_use] * characteristics[:co2_emission_factor]
                else
                  # If the `date` does not fall within the `timeframe`, `co2 emission` is zero.
                  0
                end
            end
          end
          
          ### CO<sub>2</sub> biogenic emission calculation
          # Returns the `co2 biogenic emission` (*kg*).
          committee :co2_biogenic_emission do
            #### CO<sub>2</sub> biogenic emission from fuel use, CO<sub>2</sub> biogenic emission factor, date, and timeframe
            quorum 'from fuel use, co2 biogenic emission factor, date, and timeframe',
              :needs => [:fuel_use, :co2_biogenic_emission_factor, :date],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                # Checks whether the trip `date` falls within the `timeframe`.
                date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
                if timeframe.include? date
                  # Multiplies `fuel use` (*l*) by the `co2 biogenic emission factor` (*kg / l*) to give *kg*.
                  characteristics[:fuel_use] * characteristics[:co2_biogenic_emission_factor]
                else
                  # If the `date` does not fall within the `timeframe`, `co2 biogenic emission` is zero.
                  0
                end
            end
          end
          
          ### CH<sub>4</sub> emission calculation
          # Returns the `ch4 emission` (*kg CO<sub>2</sub>e*).
          committee :ch4_emission do
            #### CH<sub>4</sub> emission from fuel use, CH<sub>4</sub> emission factor, date, and timeframe
            quorum 'from fuel use, ch4 emission factor, date, and timeframe',
              :needs => [:fuel_use, :ch4_emission_factor, :date],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                # Checks whether the trip `date` falls within the `timeframe`.
                date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
                if timeframe.include? date
                  # Multiplies `fuel use` (*l*) by the `ch4 emission factor` (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
                  characteristics[:fuel_use] * characteristics[:ch4_emission_factor]
                else
                  # If the `date` does not fall within the `timeframe`, `ch4 emission` is zero.
                  0
                end
            end
          end
          
          ### N<sub>2</sub>O emission calculation
          # Returns the `n2o emission` (*kg CO<sub>2</sub>e*)
          committee :n2o_emission do
            #### N<sub>2</sub>O emission from fuel use, N<sub>2</sub>O emission factor, date, and timeframe
            quorum 'from fuel use, n2o emission factor, date, and timeframe',
              :needs => [:fuel_use, :n2o_emission_factor, :date],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                # Checks whether the trip `date` falls within the `timeframe`.
                date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
                if timeframe.include? date
                  # Multiplies `fuel use` (*l*) by the `n2o emission factor` (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
                  characteristics[:fuel_use] * characteristics[:n2o_emission_factor]
                else
                  # If the `date` does not fall within the `timeframe`, `n2o emission` is zero.
                  0
                end
            end
          end
          
          ### HFC emission calculation
          # Returns the `hfc emission` (*kg CO<sub>2</sub>e*).
          committee :hfc_emission do
            #### HFC emission from fuel use, HFC emission factor, date, and timeframe
            quorum 'from fuel use, hfc emission factor, date, and timeframe',
              :needs => [:fuel_use, :hfc_emission_factor, :date],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                # Checks whether the trip `date` falls within the `timeframe`.
                date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
                if timeframe.include? date
                  # Multiplies `fuel use` (*l*) by the `hfc emission factor` (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
                  characteristics[:fuel_use] * characteristics[:hfc_emission_factor]
                else
                  # If the `date` does not fall within the `timeframe`, `hfc emission` is zero.
                  0
                end
            end
          end
          
          ### CO<sub>2</sub> emission factor calculation
          # Returns the `co2 emission factor` (*kg / l*).
          committee :co2_emission_factor do
            #### CO<sub>2</sub> emission factor from automobile fuel
            quorum 'from automobile fuel',
              :needs => :automobile_fuel,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [fuel](http://data.brighterplanet.com/fuels) `co2 emission factor` (*kg / l*).
                characteristics[:automobile_fuel].co2_emission_factor
            end
          end
          
          ### CO<sub>2</sub> biogenic emission factor calculation
          # Returns the `co2 biogenic emission factor` (*kg / l*).
          committee :co2_biogenic_emission_factor do
            #### CO<sub>2</sub> biogenic emission factor from automobile fuel
            quorum 'from automobile fuel',
              :needs => :automobile_fuel,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [fuel](http://data.brighterplanet.com/fuels) `co2 biogenic emission factor` (*kg / l*).
                characteristics[:automobile_fuel].co2_biogenic_emission_factor
            end
          end
          
          ### CH<sub>4</sub> emission factor calculation
          # Returns the `ch4 emission factor` (*kg CO<sub>2</sub>e / l*).
          committee :ch4_emission_factor do
            #### CH<sub>4</sub> emission factor from automobile fuel
            quorum 'from automobile fuel',
              :needs => :automobile_fuel,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [fuel](http://data.brighterplanet.com/fuels) `ch4 emission factor` (*kg CO</sub>2</sub>e / l*).
                characteristics[:automobile_fuel].ch4_emission_factor
            end
          end
          
          ### N<sub>2</sub>O emission factor calculation
          # Returns the `n2o emission factor` (*kg CO<sub>2</sub>e / l*).
          committee :n2o_emission_factor do
            #### N<sub>2</sub>O emission factor from automobile fuel
            quorum 'from automobile fuel',
              :needs => :automobile_fuel,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [fuel](http://data.brighterplanet.com/fuels) `n2o emission factor` (*kg CO</sub>2</sub>e / l*).
                characteristics[:automobile_fuel].n2o_emission_factor
            end
          end
          
          ### HFC emission factor calculation
          # Returns the `hfc emission factor` (*kg CO<sub>2</sub>e / l*).
          committee :hfc_emission_factor do
            #### HFC emission factor from automobile fuel
            quorum 'from automobile fuel',
              :needs => :automobile_fuel,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [fuel](http://data.brighterplanet.com/fuels) `hfc emission factor` (*kg CO</sub>2</sub>e / l*).
                characteristics[:automobile_fuel].hfc_emission_factor
            end
          end
          
          ### Automobile fuel calculation
          # Returns the type of `automobile fuel` used.
          committee :automobile_fuel do
            #### Automobile fuel from client input
            # **Complies:** All
            #
            # Uses the client-input [automobile fuel](http://data.brighterplanet.com/automobile_fuels).
            
            #### Automobile fuel from make model year variant
            quorum 'from make model year variant',
              :needs => :make_model_year_variant,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [variant](http://data.brighterplanet.com/automobile_make_model_year_variants) `automobile fuel`.
                characteristics[:make_model_year_variant].fuel
            end
            
            #### Default automobile fuel
            quorum 'default',
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do
                # Looks up the default [automobile fuel](http://data.brighterplanet.com/automobile_fuels).
                AutomobileFuel.fallback
            end
          end
          
          ### Fuel use calculation
          # Returns the trip `fuel use` (*l*).
          committee :fuel_use do
            #### Fuel use from fuel efficiency and distance
            quorum 'from fuel efficiency and distance',
              :needs => [:fuel_efficiency, :distance],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Divides the `distance` (*km*) by the `fuel efficiency` (*km / l*) to give *l*.
                characteristics[:distance] / characteristics[:fuel_efficiency]
            end
          end
          
          ### Distance calculation
          # Returns the trip `distance` (*km*).
          committee :distance do
            #### Distance from client input
            # **Complies:** All
            #
            # Uses the client-input `distance` (*km*).
            
            #### Distance from origin and destination locations
            quorum 'from origin and destination locations',
              :needs => [:origin_location, :destination_location, :mapquest_api_key],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Uses the [Mapquest directions API](http://developer.mapquest.com/web/products/dev-services/directions-ws) to calculate distance by road between the origin and destination locations.
                mapquest = MapQuestDirections.new characteristics[:origin_location],
                                                  characteristics[:destination_location],
                                                  characteristics[:mapquest_api_key]
                begin
                  mapquest.distance_in_kilometres
                rescue
                  nil
                end
            end
            
            #### Distance from duration and speed
            quorum 'from duration and speed',
              :needs => [:duration, :speed],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Divides the `duration` (*minutes*) by 60 and multiplies by the `speed` (*km / hour*) to give *km*.
                (characteristics[:duration] / 60.0) * characteristics[:speed]
            end
            
            #### Distance from country
            quorum 'from country',
              :needs => :country,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [country](http://data.brighterplanet.com/countries) `automobile trip distance`.
                characteristics[:country].automobile_trip_distance
            end
          end
          
          ### Destination location calculation
          # Returns the `destination location` (*lat / lng*).
          committee :destination_location do
            #### Destination location from destination
            quorum 'from destination',
              :needs => :destination,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Uses the [Geokit](http://geokit.rubyforge.org/) geocoder to determine the destination location (*lat / lng*).
                code = Geokit::Geocoders::MultiGeocoder.geocode characteristics[:destination].to_s
                code.ll == ',' ? nil : code.ll
            end
          end
          
          ### Origin location committee
          # Returns the `origin location` (*lat / lng*).
          committee :origin_location do
            #### Destination location from destination
            quorum 'from origin',
              :needs => :origin,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Uses the [Geokit](http://geokit.rubyforge.org/) geocoder to determine the origin location (*lat / lng*).
                code = Geokit::Geocoders::MultiGeocoder.geocode characteristics[:origin].to_s
                code.ll == ',' ? nil : code.ll
            end
          end
          
          ### Destination calculation
          # Returns the client-input `destination`.
          
          ### Origin calculation
          # Returns the client-input `origin`.
          
          ### Duration calculation
          # Returns the client-input `duration` (*minutes*).
          
          ### Speed calculation
          # Returns the average `speed` at which the automobile travels (*km / hour*).
          committee :speed do
            #### Speed from client input
            # **Complies:** All
            #
            # Uses the client-input `speed` (*km / hour*).
            
            #### Speed from urbanity and country
            quorum 'from urbanity and country',
              :needs => [:urbanity, :country],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [country](http://data.brighterplanet.com/countries) average city and highway driving speeds and calculates the harmonic mean of those speeds weighted by `urbanity`.
                1 / (characteristics[:urbanity] / characteristics[:country].automobile_city_speed + (1 - characteristics[:urbanity]) / characteristics[:country].automobile_highway_speed)
            end
          end
          
          ### Fuel efficiency calculation
          # Returns the `fuel efficiency` (*km / l*).
          committee :fuel_efficiency do
            #### Fuel efficiency from client input
            # **Complies:** All
            #
            # Uses the client-input `fuel efficiency` (*km / l*).
            
            #### Fuel efficiency from make model year variant and urbanity
            quorum 'from make model year variant and urbanity',
              :needs => [:make_model_year_variant, :urbanity],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the city and highway fuel efficiencies of the automobile [make model year variant](http://data.brighterplanet.com/automobile_make_model_year_variants) (*km / l*).
                fuel_efficiency_city = characteristics[:make_model_year_variant].fuel_efficiency_city
                fuel_efficiency_highway = characteristics[:make_model_year_variant].fuel_efficiency_highway
                urbanity = characteristics[:urbanity]
                if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                  # Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`.
                  1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))
                end
            end
            
            #### Fuel efficiency from make model year and urbanity
            quorum 'from make model year and urbanity',
              :needs => [:make_model_year, :urbanity],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the city and highway fuel efficiencies of the automobile [make model year](http://data.brighterplanet.com/automobile_make_model_years) (*km / l*).
                fuel_efficiency_city = characteristics[:make_model_year].fuel_efficiency_city
                fuel_efficiency_highway = characteristics[:make_model_year].fuel_efficiency_highway
                urbanity = characteristics[:urbanity]
                if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                  # Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`.
                  1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))
                end
            end
            
            #### Fuel efficiency from make model and urbanity
            quorum 'from make model and urbanity',
              :needs => [:make_model, :urbanity],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the city and highway fuel efficiencies of the automobile [make model](http://data.brighterplanet.com/automobile_make_models) (*km / l*).
                fuel_efficiency_city = characteristics[:make_model].fuel_efficiency_city
                fuel_efficiency_highway = characteristics[:make_model].fuel_efficiency_highway
                urbanity = characteristics[:urbanity]
                if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                  # Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`.
                  1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))
                end
            end
            
            #### Fuel efficiency from size class, hybridity multiplier, and urbanity
            quorum 'from size class, hybridity multiplier, and urbanity',
              :needs => [:size_class, :hybridity_multiplier, :urbanity],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the automobile [size class](http://data.brighterplanet.com/automobile_makes) city and highway fuel efficiency (*km / l*).
                fuel_efficiency_city = characteristics[:size_class].fuel_efficiency_city
                fuel_efficiency_highway = characteristics[:size_class].fuel_efficiency_highway
                urbanity = characteristics[:urbanity]
                if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                  # Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`, and multiplies the result by the `hybridity multiplier`.
                  (1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))) * characteristics[:hybridity_multiplier]
                end
            end
            
            #### Fuel efficiency from make year and hybridity multiplier
            quorum 'from make year and hybridity multiplier',
              :needs => [:make_year, :hybridity_multiplier],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the automobile [make year](http://data.brighterplanet.com/automobile_make_years) combined fuel efficiency (*km / l*) and multiplies it by the `hybridity multiplier`.
                characteristics[:make_year].fuel_efficiency * characteristics[:hybridity_multiplier]
            end
            
            #### Fuel efficiency from make and hybridity multiplier
            quorum 'from make and hybridity multiplier',
              :needs => [:make, :hybridity_multiplier],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the automobile [make](http://data.brighterplanet.com/automobile_makes) combined fuel efficiency (*km / l*) and multiplies it by the `hybridity multiplier`.
                if characteristics[:make].fuel_efficiency.present?
                  characteristics[:make].fuel_efficiency * characteristics[:hybridity_multiplier]
                else
                  nil
                end
            end
            
            #### Fuel efficiency from hybridity multiplier and country
            quorum 'from hybridity multiplier and country',
              :needs => [:hybridity_multiplier, :country],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [country](http://data.brighterplanet.com/countries) `automobile fuel efficiency` and multiplies it by the `hybridity multiplier`.
                characteristics[:country].automobile_fuel_efficiency * characteristics[:hybridity_multiplier]
            end
          end
          
          ### Hybridity multiplier calculation
          # Returns the `hybridity multiplier`.
          # This value may be used to adjust the fuel efficiency based on whether the automobile is a hybrid or conventional vehicle.
          committee :hybridity_multiplier do
            #### Hybridity multiplier from size class, hybridity, and urbanity
            quorum 'from size class, hybridity, and urbanity', 
              :needs => [:size_class, :hybridity, :urbanity],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the appropriate city and highway hybridity multipliers for the automobile [size class](http://data.brighterplanet.com/automobile_size_classes).
                drivetrain = characteristics[:hybridity] ? :hybrid : :conventional
                urbanity = characteristics[:urbanity]
                size_class = characteristics[:size_class]
                fuel_efficiency_multipliers = {
                  :city => size_class.send(:"#{drivetrain}_fuel_efficiency_city_multiplier"),
                  :highway => size_class.send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
                }
                if fuel_efficiency_multipliers.values.any?(&:present?)
                  # Calculates the harmonic mean of those multipliers, weighted by `urbanity`.
                  1.0 / ((urbanity / fuel_efficiency_multipliers[:city]) + ((1.0 - urbanity) / fuel_efficiency_multipliers[:highway]))
                else
                  nil
                end
            end
            
            #### Hybridity multiplier from hybridity and urbanity
            quorum 'from hybridity and urbanity',
              :needs => [:hybridity, :urbanity],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the appropriate default city and highway hybridity multipliers.
                drivetrain = characteristics[:hybridity] ? :hybrid : :conventional
                urbanity = characteristics[:urbanity]
                fuel_efficiency_multipliers = {
                  :city => AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_city_multiplier"),
                  :highway => AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
                }
                # Calculates the harmonic mean of those multipliers, weighted by `urbanity`.
                1.0 / ((urbanity / fuel_efficiency_multipliers[:city]) + ((1.0 - urbanity) / fuel_efficiency_multipliers[:highway]))
            end
            
            #### Default hybridity multiplier
            quorum 'default',
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do
                # Uses a default `hybridity multiplier` of 1.
                base.fallback.hybridity_multiplier
            end
          end
          
          ### Urbanity calculation
          # Returns the `urbanity`.
          # This is the fraction of the total distance driven that occurs on towns and city streets as opposed to highways (defined using a 45 miles per hour "speed cutpoint").
          committee :urbanity do
            #### Urbanity from urbanity estimate
            quorum 'from urbanity estimate',
              :needs => :urbanity_estimate,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Uses the `urbanity estimate` if it is from zero to one.
                if characteristics[:urbanity_estimate] >= 0 and characteristics[:urbanity_estimate] <= 1
                  characteristics[:urbanity_estimate]
                end
            end
            
            #### Urbanity from country
            quorum 'from country',
              :needs => :country,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [country](http://data.brighterplanet.com/countries) `automobile urbanity`.
                characteristics[:country].automobile_urbanity
            end
          end
          
          ### Urbanity estimate calculation
          # Returns the client-input `urbanity estimate`. This is the fraction of the total distance driven that occurs on towns and city streets as opposed to highways (defined using a 45 miles per hour "speed cutpoint").
          
          ### Hybridity calculation
          # Returns the client-input `hybridity`. This indicates whether the automobile is a hybrid electric vehicle or a conventional vehicle.
          
          ### Size class calculation
          # Returns the client-input automobile [size class](http://data.brighterplanet.com/automobile_size_classes).
          
          ### Make model year variant calculation
          # Returns the client-input automobile [make model year variant](http://data.brighterplanet.com/automobile_make_model_year_variants).
          
          ### Make model year calculation
          # Returns the client-input automobile [make model year](http://data.brighterplanet.com/automobile_make_model_years).
          
          ### Make model calculation
          # Returns the client-input automobile [make model](http://data.brighterplanet.com/automobile_make_models).
          
          ### Make year calculation
          # Returns the client-input automobile [make year](http://data.brighterplanet.com/automobile_make_years).
          
          ### Make calculation
          # Returns the client-input automobile [make](http://data.brighterplanet.com/automobile_makes).
          
          ### Country calculation
          # Returns the `country` in which the trip occurred.
          committee :country do
            #### Country from client input
            # **Complies:** All
            #
            # Uses the client-input `country`.
            
            #### Default country
            quorum 'default',
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do
                # Uses an artificial country that contains global averages.
                Country.fallback
            end
          end
          
          ### Date calculation
          # Returns the `date` on which the trip occurred.
          committee :date do
            #### Date from client input
            # **Complies:** All
            #
            # Uses the client-input `date`.
            
            #### Date from timeframe
            quorum 'from timeframe',
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO-14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                # Assumes the trip occurred on the first day of the `timeframe`.
                timeframe.from
            end
          end
          
          ### Timeframe calculation
          # Returns the `timeframe`.
          # This is the period during which to calculate emissions.
            
            #### Timeframe from client input
            # **Complies:** All
            #
            # Uses the client-input `timeframe`.
            
            #### Default timeframe
            # **Complies:** All
            #
            # Uses the current calendar year.
          
          ### Mapquest API key lookup
          # Returns Brighter Planet's Mapquest API key
          committee :mapquest_api_key do
            #### Default Mapquest API key
            quorum 'default',
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do
                # Uses Brighter Planet's Mapquest API key.
                ENV['MAPQUEST_API_KEY']
            end
          end
        end
      end
      
      class Mapper
        include Geokit::Mappable
      end
    end
  end
end
