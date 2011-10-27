# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

### Automobile impact model
# This model is used by [Brighter Planet](http://brighterplanet.com)'s [CM1 web service](http://carbon.brighterplanet.com) to calculate the impacts of an automobile trip, such as energy use and greenhouse gas emissions.

##### Timeframe
# The model calculates impacts that occured during a particular time period (`timeframe`).
# For example if the `timeframe` is February 2010, an automobile put into use (`acquisition`) in December 2009 and taken out of use (`retirement`) in March 2010 will have impacts because it was in use during January 2010.
# An automobile put into use in March 2010 or taken out of use in January 2010 will have zero impacts, because it was not in use during February 2010.
#
# The default `timeframe` is the current calendar year.

##### Calculations
# The final impacts are the result of the calculations below. These are performed in reverse order, starting with the last calculation listed and finishing with the greenhouse gas emissions calculation.
#
# Each calculation listing shows:
#
# * **value returned** (***units of measurement***)
# * a description of the value
# * calculation methods, listed from most to least preferred
#
# Some methods need `values` returned by prior calculations. If any of these `values` are unknown the method is skipped.
# If all of the methods for a calculation are skipped, the value the calculation would return is unknown.

##### Standard compliance
# When compliance with a particular standard is requested, all methods that do not comply with that standard are ignored.
# Thus any `values` a method needs will have been calculated using a compliant method or will be unknown.
# To see which standards a method complies with, look at the `:complies =>` section of the code in the right column.
# Client input complies with all standards.

##### Collaboration
# Contributions to this carbon model are actively encouraged and warmly welcomed. This library includes a comprehensive test suite to ensure that your changes do not cause regressions. All changes should include test coverage for new functionality. Please see [sniff](https://github.com/brighterplanet/sniff#readme), our emitter testing framework, for more information.
module BrighterPlanet
  module AutomobileTrip
    module ImpactModel
      def self.included(base)
        base.decide :impact, :with => :characteristics do
          # * * *
          
          #### Carbon (*kg CO<sub>2</sub>e*)
          # The trip's total greenhouse gas emissions from anthropogenic sources during `timeframe`.
          committee :carbon do
            #### Greenhouse gas emission from CO<sub>2</sub> emission, CH<sub>4</sub> emission, N<sub>2</sub>O emission, and HFC emission
            quorum 'from co2 emission, ch4 emission, n2o emission, and hfc emission', :needs => [:co2_emission, :ch4_emission, :n2o_emission, :hfc_emission],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Sum `co2 emission` (*kg*), `ch4 emission` (*kg CO<sub>2</sub>e*), `n2o emission` (*kg CO<sub>2</sub>e*), and `hfc emission` (*kg CO<sub>2</sub>e*), to give *kg CO<sub>2</sub>e*.
                characteristics[:co2_emission] + characteristics[:ch4_emission] + characteristics[:n2o_emission] + characteristics[:hfc_emission]
            end
          end
          
          #### CO<sub>2</sub> emission (*kg*)
          # The trip's CO<sub>2</sub> emissions from anthropogenic sources during `timeframe`.
          committee :co2_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel`'s co2 emission factor (*kg / l*) to give *kg*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].co2_emission_factor
            end
          end
          
          #### CO<sub>2</sub> biogenic emission (*kg*)
          # The trip's CO<sub>2</sub> emissions from biogenic sources during `timeframe`.
          committee :co2_biogenic_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel`'s co2 biogenic emission factor (*kg / l*) to give *kg*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].co2_biogenic_emission_factor
            end
          end
          
          #### CH<sub>4</sub> emission (*kg CO<sub>2</sub>e*)
          # The trip's CH<sub>4</sub> emissions during `timeframe`.
          committee :ch4_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel`'s ch4 emission factor (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].ch4_emission_factor
            end
          end
          
          #### N<sub>4</sub>O emission (*kg CO<sub>2</sub>e*)
          # The trip's N<sub>2</sub>O emissions during `timeframe`.
          committee :n2o_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel`'s n2o emission factor (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].n2o_emission_factor
            end
          end
          
          #### HFC emission (*kg CO<sub>2</sub>e*)
          # The trip's HFC emissions during `timeframe`.
          committee :hfc_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel`'s hfc emission factor (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].hfc_emission_factor
            end
          end
          
          #### Automobile fuel
          # The automobile's [fuel type](http://data.brighterplanet.com/automobile_fuels).
          committee :automobile_fuel do
            # Use client input, if available.
            
            # Otherwise look up the `make model year`'s automobile fuel
            quorum 'from make model year', :needs => :make_model_year,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make_model_year].automobile_fuel
            end
            
            # Otherwise look up the average [automobile fuel](http://data.brighterplanet.com/automobile_fuels).
            quorum 'default',
              :complies => [:ghg_protocol_scope_3, :iso] do
                AutomobileFuel.fallback
            end
          end
          
          #### Fuel use (*l*)
          # The trip's fuel use during `timeframe`.
          committee :fuel_use do
            # Use client input, if available.
            
            # Otherwise if `date` falls within `timeframe`, divide `distance` (*km*) by `fuel efficiency` (*km / l*) to give *l*.
            # Otherwise fuel use is zero.
            quorum 'from fuel efficiency, distance, date, and timeframe', :needs => [:fuel_efficiency, :distance, :date],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
                timeframe.include?(date) ? characteristics[:distance] / characteristics[:fuel_efficiency] : 0
            end
          end
          
          #### Distance (*km*)
          # The trip's distance.
          committee :distance do
            # Use client input, if available.
            
            # Otherwise use the [Mapquest directions API](http://developer.mapquest.com/web/products/dev-services/directions-ws) to calculate the distance by road between `origin_location` and `destination_location` in *km*.
            quorum 'from origin and destination locations', :needs => [:origin_location, :destination_location],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                mapquest = ::MapQuestDirections.new characteristics[:origin_location].ll, characteristics[:destination_location].ll
                mapquest.status.to_i == 0 ? Nokogiri::XML(mapquest.xml).css("distance").first.text.to_f.miles.to(:kilometres) : nil
            end
            
            # Otherwise divide `duration` (*seconds*) by 3600 to give *hours* and multiply by `speed` (*km / hour*) to give *km*.
            quorum 'from duration and speed', :needs => [:duration, :speed],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                (characteristics[:duration] / 60.0 / 60.0) * characteristics[:speed]
            end
            
            # Otherwise look up the `country`'s average automobile trip distance (*km*).
            quorum 'from country', :needs => :country,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:country].automobile_trip_distance
            end
          end
          
          #### Destination location (*lat, lng*)
          # The latitude and longitude of the trip's destination.
          committee :destination_location do
            # Use the [Geokit](http://geokit.rubyforge.org/) geocoder to determine the `destination`'s location (*lat, lng*).
            quorum 'from destination', :needs => :destination,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                location = ::Geokit::Geocoders::MultiGeocoder.geocode characteristics[:destination].to_s
                location.success ? location : nil
            end
          end
          
          #### Origin location (*lat, lng*)
          # The latitude and longitude of the trip's origin.
          committee :origin_location do
            #### Destination location from destination
            quorum 'from origin', :needs => :origin,
              # Use the [Geokit](http://geokit.rubyforge.org/) geocoder to determine the `origin`'s location (*lat, lng*).
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                location = ::Geokit::Geocoders::MultiGeocoder.geocode characteristics[:origin].to_s
                location.success ? location : nil
            end
          end
          
          #### Destination
          # The trip's destination.
          #
          # Use client input if available.
          
          #### Origin
          # The trip's origin.
          #
          # Use client input if available.
          
          #### Duration (*seconds*)
          # The trip's duration.
          #
          # Use client input if available
          
          #### Speed (*km / hr*)
          # The trip's average speed.
          committee :speed do
            # Use client input, if available.
            
            # Otherwise look up the `country`'s average automobile city speed (*km / hr*) and automobile highway speed (*km / hr*).
            # Calculate the harmonic mean of those speeds weighted by `urbanity` to give *km / hr*.
            quorum 'from urbanity and country', :needs => [:urbanity, :country],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                1 / (characteristics[:urbanity] / characteristics[:country].automobile_city_speed + (1 - characteristics[:urbanity]) / characteristics[:country].automobile_highway_speed)
            end
          end
          
          #### Fuel efficiency (*km / l*)
          # The automobile's fuel efficiency.
          committee :fuel_efficiency do
            # Use client input, if available.
            
            # Otherwise look up the `make model year`'s fuel efficiency city (*km / l*) and fuel efficiency highway (*km / l*).
            # Calculate the harmonic mean of those fuel efficiencies, weighted by `urbanity`, to give *km / l*.
            quorum 'from make model year and urbanity', :needs => [:make_model_year, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                1.0 / (
                  (characteristics[:urbanity]         / characteristics[:make_model_year].fuel_efficiency_city) +
                  ((1.0 - characteristics[:urbanity]) / characteristics[:make_model_year].fuel_efficiency_highway)
                )
            end
            
            # Otherwise look up the `make model`'s fuel efficiency city (*km / l*) and fuel efficiency highway (*km / l*).
            # Calculate the harmonic mean of those fuel efficiencies, weighted by `urbanity`, to give *km / l*.
            quorum 'from make model and urbanity', :needs => [:make_model, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                1.0 / (
                  (characteristics[:urbanity]         / characteristics[:make_model].fuel_efficiency_city) +
                  ((1.0 - characteristics[:urbanity]) / characteristics[:make_model].fuel_efficiency_highway)
                )
            end
            
            # Otherwise look up the `size class`' `fuel efficiency city`(*km / l*) and `fuel efficiency highway` (*km / l*).
            # Calculate the harmonic mean of those fuel efficiencies, weighted by `urbanity`, to give *km / l*.
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from size class, hybridity multiplier, and urbanity', :needs => [:size_class, :hybridity_multiplier, :urbanity],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                (1.0 / (
                  (characteristics[:urbanity]         / characteristics[:size_class].fuel_efficiency_city) +
                  ((1.0 - characteristics[:urbanity]) / characteristics[:size_class].fuel_efficiency_highway)
                )) * characteristics[:hybridity_multiplier]
            end
            
            # Otherwise look up the `make year`'s `fuel efficiency` (*km / l*).
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from make year and hybridity multiplier', :needs => [:make_year, :hybridity_multiplier],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make_year].fuel_efficiency * characteristics[:hybridity_multiplier]
            end
            
            # Otherwise look up the `make`'s `fuel efficiency` (*km / l*).
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from make and hybridity multiplier', :needs => [:make, :hybridity_multiplier],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make].fuel_efficiency * characteristics[:hybridity_multiplier]
            end
            
            # Otherwise look up the `country`'s average `automobile fuel efficiency` (*km / l*).
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from hybridity multiplier and country', :needs => [:hybridity_multiplier, :country],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:country].automobile_fuel_efficiency * characteristics[:hybridity_multiplier]
            end
          end
          
          #### Hybridity multiplier (*dimensionless*)
          # A multiplier used to adjust fuel efficiency if we know the automobile is a hybrid or conventional vehicle.
          committee :hybridity_multiplier do
            # Check whether the `size class` has `hybridity` multipliers for city and highway fuel efficiency.
            # If it does, calculate the harmonic mean of those multipliers, weighted by `urbanity`.
            quorum 'from size class, hybridity, and urbanity', :needs => [:size_class, :hybridity, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                drivetrain = characteristics[:hybridity].value ? :hybrid : :conventional
                city_multiplier    = characteristics[:size_class].send(:"#{drivetrain}_fuel_efficiency_city_multiplier")
                highway_multiplier = characteristics[:size_class].send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
                
                if city_multiplier and highway_multiplier
                  1.0 / ((characteristics[:urbanity] / city_multiplier) + ((1.0 - characteristics[:urbanity]) / highway_multiplier))
                end
            end
            
            # Otherwise look up the `hybridity`'s average city and highway fuel efficiency multipliers.
            # Calculate the harmonic mean of those multipliers, weighted by `urbanity`.
            quorum 'from hybridity and urbanity', :needs => [:hybridity, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                drivetrain = characteristics[:hybridity].value ? :hybrid : :conventional
                city_multiplier = AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_city_multiplier")
                highway_multiplier = AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
                
                1.0 / ((characteristics[:urbanity] / city_multiplier) + ((1.0 - characteristics[:urbanity]) / highway_multiplier))
            end
            
            # Otherwise use a multiplier of 1.0.
            quorum 'default',
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do
                1.0
            end
          end
          
          #### Hybridity (*boolean*)
          # True if the automobile is a hybrid vehicle. False if the automobile is a conventional vehicle.
          #
          # Use client input, if available.
          
          #### Size class
          # The automobile's [size class](http://data.brighterplanet.com/automobile_size_classes).
          #
          # Use client input, if available.
          
          #### Urbanity (*%*)
          # The fraction of the total distance driven that is in towns and cities rather than highways.
          # Highways are defined as all driving at speeds of 45 miles per hour or greater.
          committee :urbanity do
            # Look up the `country`'s average automobile urbanity (*%*).
            quorum 'from country', :needs => :country,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:country].automobile_urbanity
            end
          end
          
          #### Country
          # The [country](http://data.brighterplanet.com/countries) in which the trip occurred.
          committee :country do
            # Use client input, if available.
            
            # Otherwise use an artificial country that contains global averages.
            quorum 'default',
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do
                Country.fallback
            end
          end
          
          #### Make model year
          # The automobile's [make, model, and year](http://data.brighterplanet.com/automobile_make_model_years).
          committee :make_model_year do
            # Check whether the `make`, `model`, and `year` combination matches any automobiles in our database.
            # If it doesn't then we don't know `make model year`.
            quorum 'from make, model, and year', :needs => [:make, :model, :year],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileMakeModelYear.find_by_make_name_and_model_name_and_year(characteristics[:make].name, characteristics[:model].name, characteristics[:year].year)
            end
          end
          
          #### Make year
          # The automobile's [make and year](http://data.brighterplanet.com/automobile_make_years).
          committee :make_year do
            # Check whether the `make` and `year` combination matches any automobiles in our database.
            # If it doesn't then we don't know `make year`.
            quorum 'from make and year', :needs => [:make, :year],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileMakeYear.find_by_make_name_and_year(characteristics[:make].name, characteristics[:year].year)
            end
          end
          
          #### Make model
          # The automobile's [make and model](http://data.brighterplanet.com/automobile_make_models).
          committee :make_model do
            # Check whether the `make` and `model` combination matches any automobiles in our database.
            # If it doesn't then we don't know `make model`.
            quorum 'from make and model', :needs => [:make, :model],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileMakeModel.find_by_make_name_and_model_name(characteristics[:make].name, characteristics[:model].name)
            end
          end
          
          #### Year
          # The automobile's [year of manufacture](http://data.brighterplanet.com/automobile_years).
          #
          # Use client input, if available.
          
          #### Model
          # The automobile's [model](http://data.brighterplanet.com/automobile_models).
          #
          # Use client input, if available.
          
          #### Make
          # The automobile's [make](http://data.brighterplanet.com/automobile_makes).
          #
          # Use client input, if available.
          
          #### Date (*date*)
          # The day the trip occurred.
          committee :date do
            # Use client input, if available.
            
            # Otherwise use the first day of `timeframe`.
            quorum 'from timeframe',
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                timeframe.from
            end
          end
        end
      end
    end
  end
end
