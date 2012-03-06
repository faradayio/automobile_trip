# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

### Automobile trip impact model
# This model is used by the [Brighter Planet](http://brighterplanet.com) [CM1 web service](http://impact.brighterplanet.com) to calculate the impacts of an automobile trip, such as energy use and greenhouse gas emissions.

##### Timeframe
# The model calculates impacts that occured during a particular time period (`timeframe`).
# For example if the `timeframe` is February 2010, a trip that occurred (`date`) on February 15, 2010 will have impacts, but a trip that occurred on January 31, 2010 will have zero impacts.
#
# The default `timeframe` is the current calendar year.

##### Calculations
# The final impacts are the result of the calculations below. These are performed in reverse order, starting with the last calculation listed and finishing with the greenhouse gas emissions calculation.
#
# Each calculation listing shows:
#
# * value returned (*units of measurement*)
# * description of the value
# * calculation methods, listed from most to least preferred
#
# Some methods use `values` returned by prior calculations. If any of these `values` are unknown the method is skipped.
# If all the methods for a calculation are skipped, the value the calculation would return is unknown.

##### Standard compliance
# When compliance with a particular standard is requested, all methods that do not comply with that standard are ignored.
# Thus any `values` a method needs will have been calculated using a compliant method or will be unknown.
# To see which standards a method complies with, look at the `:complies =>` section of the code in the right column.
#
# Client input complies with all standards.

##### Collaboration
# Contributions to this impact model are actively encouraged and warmly welcomed. This library includes a comprehensive test suite to ensure that your changes do not cause regressions. All changes should include test coverage for new functionality. Please see [sniff](https://github.com/brighterplanet/sniff#readme), our emitter testing framework, for more information.
module BrighterPlanet
  module AutomobileTrip
    module ImpactModel
      def self.included(base)
        base.decide :impact, :with => :characteristics do
          # * * *
          
          #### Carbon (*kg CO<sub>2</sub>e*)
          # *The trip's total anthropogenic greenhouse gas emissions during `timeframe`.*
          committee :carbon do
            # Sum `co2 emission` (*kg*), `ch4 emission` (*kg CO<sub>2</sub>e*), `n2o emission` (*kg CO<sub>2</sub>e*), and `hfc emission` (*kg CO<sub>2</sub>e*) to give *kg CO<sub>2</sub>e*.
            quorum 'from co2 emission, ch4 emission, n2o emission, and hfc emission', :needs => [:co2_emission, :ch4_emission, :n2o_emission, :hfc_emission],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:co2_emission] + characteristics[:ch4_emission] + characteristics[:n2o_emission] + characteristics[:hfc_emission]
            end
          end
          
          #### CO<sub>2</sub> emission (*kg*)
          # *The trip's CO<sub>2</sub> emissions from anthropogenic sources during `timeframe`.*
          committee :co2_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel` co2 emission factor (*kg / l*) to give *kg*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].co2_emission_factor
            end
          end
          
          #### CO<sub>2</sub> biogenic emission (*kg*)
          # *The trip's CO<sub>2</sub> emissions from biogenic sources during `timeframe`.*
          committee :co2_biogenic_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel` co2 biogenic emission factor (*kg / l*) to give *kg*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].co2_biogenic_emission_factor
            end
          end
          
          #### CH<sub>4</sub> emission (*kg CO<sub>2</sub>e*)
          # *The trip's CH<sub>4</sub> emissions during `timeframe`.*
          committee :ch4_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel` ch4 emission factor (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].ch4_emission_factor
            end
          end
          
          #### N<sub>4</sub>O emission (*kg CO<sub>2</sub>e*)
          # *The trip's N<sub>2</sub>O emissions during `timeframe`.*
          committee :n2o_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel` n2o emission factor (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].n2o_emission_factor
            end
          end
          
          #### HFC emission (*kg CO<sub>2</sub>e*)
          # *The trip's HFC emissions during `timeframe`.*
          committee :hfc_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel` hfc emission factor (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].hfc_emission_factor
            end
          end
          
          #### Energy (*MJ*)
          # *The trip's energy use during `timeframe`.*
          committee :energy do
            # Multiply `fuel use` (*l*) by the `automobile fuel` energy content (*MJ / l*) to give *MJ*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel] do |characteristics|
              characteristics[:fuel_use] * characteristics[:automobile_fuel].energy_content
            end
          end
          
          #### Automobile fuel
          # *The automobile's [fuel type](http://data.brighterplanet.com/automobile_fuels).*
          committee :automobile_fuel do
            # Use client input, if available.
            
            # Otherwise use the `make model year` [automobile fuel](http://data.brighterplanet.com/automobile_fuels).
            quorum 'from make model year', :needs => :make_model_year,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make_model_year].automobile_fuel
            end
            
            # Otherwise use the average [automobile fuel](http://data.brighterplanet.com/automobile_fuels).
            quorum 'default',
              :complies => [:ghg_protocol_scope_3, :iso] do
                AutomobileFuel.fallback
            end
          end
          
          #### Fuel use (*l*)
          # *The trip's fuel use during `timeframe`.*
          committee :fuel_use do
            # Use client input, if available.
            
            # Otherwise if `date` falls within `timeframe`, divide `distance` (*km*) by `fuel efficiency` (*km / l*) to give *l*.
            #
            # Otherwise fuel use is zero.
            quorum 'from fuel efficiency, distance, date, and timeframe', :needs => [:fuel_efficiency, :distance, :date],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
=begin
                FIXME TODO user-input date should already be coerced
=end
                date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
                timeframe.include?(date) ? characteristics[:distance] / characteristics[:fuel_efficiency] : 0
            end
          end
          
          #### Distance (*km*)
          # *The trip's distance.*
          committee :distance do
            # Use client input, if available.
            
            # Otherwise use the [Mapquest directions API](http://developer.mapquest.com/web/products/dev-services/directions-ws) to calculate the distance by road between `origin_location` and `destination_location` in *km*.
            quorum 'from origin and destination locations', :needs => [:origin_location, :destination_location],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                mapquest = ::MapQuestDirections.new characteristics[:origin_location].ll, characteristics[:destination_location].ll
                mapquest.status.to_i == 0 ? Nokogiri::XML(mapquest.xml).css("distance").first.text.to_f.miles.to(:kilometres) : nil
            end
            
            # Otherwise divide `duration` (*seconds*) by 3600 (*seconds / hour*) and multiply by `speed` (*km / hour*) to give *km*.
            quorum 'from duration and speed', :needs => [:duration, :speed],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                (characteristics[:duration] / 60.0 / 60.0) * characteristics[:speed]
            end
            
            # Otherwise use the `safe country` average automobile trip distance (*km*).
            quorum 'from safe country', :needs => :safe_country,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:safe_country].automobile_trip_distance
            end
          end
          
          #### Destination location (*lat, lng*)
          # *The latitude and longitude of the trip's destination.*
          committee :destination_location do
            # Use the [Geokit](http://geokit.rubyforge.org/) geocoder to determine the `destination` location (*lat, lng*).
            quorum 'from destination', :needs => :destination,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                location = ::Geokit::Geocoders::MultiGeocoder.geocode characteristics[:destination].to_s
                location.success ? location : nil
            end
          end
          
          #### Origin location (*lat, lng*)
          # *The latitude and longitude of the trip's origin.*
          committee :origin_location do
            #### Destination location from destination
            quorum 'from origin', :needs => :origin,
              # Use the [Geokit](http://geokit.rubyforge.org/) geocoder to determine the `origin` location (*lat, lng*).
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                location = ::Geokit::Geocoders::MultiGeocoder.geocode characteristics[:origin].to_s
                location.success ? location : nil
            end
          end
          
          #### Destination
          # *The trip's destination.*
          #
          # Use client input if available.
          
          #### Origin
          # *The trip's origin.*
          #
          # Use client input if available.
          
          #### Duration (*seconds*)
          # *The trip's duration.*
          #
          # Use client input if available
          
          #### Speed (*km / hour*)
          # *The trip's average speed.*
          committee :speed do
            # Use client input, if available.
            
            # Otherwise look up the `safe country` average automobile city speed (*km / hour*) and automobile highway speed (*km / hour*).
            # Calculate the harmonic mean of those speeds weighted by `urbanity` to give *km / hour*.
            quorum 'from urbanity and safe country', :needs => [:urbanity, :safe_country],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                1 / (characteristics[:urbanity] / characteristics[:safe_country].automobile_city_speed + (1 - characteristics[:urbanity]) / characteristics[:safe_country].automobile_highway_speed)
            end
          end
          
          #### Fuel efficiency (*km / l*)
          # *The automobile's fuel efficiency.*
          committee :fuel_efficiency do
            # Use client input, if available.
            
            # Otherwise look up the `make model year` fuel efficiency city (*km / l*) and fuel efficiency highway (*km / l*).
            # Calculate the harmonic mean of those fuel efficiencies, weighted by `urbanity`, to give *km / l*.
            quorum 'from make model year and urbanity', :needs => [:make_model_year, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                1.0 / (
                  (characteristics[:urbanity]         / characteristics[:make_model_year].fuel_efficiency_city) +
                  ((1.0 - characteristics[:urbanity]) / characteristics[:make_model_year].fuel_efficiency_highway)
                )
            end
            
            # Otherwise look up the `make model` fuel efficiency city (*km / l*) and fuel efficiency highway (*km / l*).
            # Calculate the harmonic mean of those fuel efficiencies, weighted by `urbanity`, to give *km / l*.
            quorum 'from make model and urbanity', :needs => [:make_model, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                1.0 / (
                  (characteristics[:urbanity]         / characteristics[:make_model].fuel_efficiency_city) +
                  ((1.0 - characteristics[:urbanity]) / characteristics[:make_model].fuel_efficiency_highway)
                )
            end
            
            # Otherwise look up the `size class` fuel efficiency city (*km / l*) and fuel efficiency highway (*km / l*).
            # Calculate the harmonic mean of those fuel efficiencies, weighted by `urbanity`, to give *km / l*.
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from size class, hybridity multiplier, and urbanity', :needs => [:size_class, :hybridity_multiplier, :urbanity],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                (1.0 / (
                  (characteristics[:urbanity]         / characteristics[:size_class].fuel_efficiency_city) +
                  ((1.0 - characteristics[:urbanity]) / characteristics[:size_class].fuel_efficiency_highway)
                )) * characteristics[:hybridity_multiplier]
            end
            
            # Otherwise look up the `make year` fuel efficiency (*km / l*).
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from make year and hybridity multiplier', :needs => [:make_year, :hybridity_multiplier],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make_year].fuel_efficiency * characteristics[:hybridity_multiplier]
            end
            
            # Otherwise look up the `make` fuel efficiency (*km / l*).
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from make and hybridity multiplier', :needs => [:make, :hybridity_multiplier],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make].fuel_efficiency * characteristics[:hybridity_multiplier]
            end
            
            # Otherwise look up the `safe country` average `automobile fuel efficiency` (*km / l*).
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from hybridity multiplier and safe country', :needs => [:hybridity_multiplier, :safe_country],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:safe_country].automobile_fuel_efficiency * characteristics[:hybridity_multiplier]
            end
          end
          
          #### Hybridity multiplier (*dimensionless*)
          # *A multiplier used to adjust fuel efficiency if we know the automobile is a hybrid or conventional vehicle.*
          committee :hybridity_multiplier do
            # Check whether the `size class` has `hybridity` multipliers for city and highway fuel efficiency.
            # If it does, calculate the harmonic mean of those multipliers, weighted by `urbanity`.
            quorum 'from size class, hybridity, and urbanity', :needs => [:size_class, :hybridity, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                drivetrain = (characteristics[:hybridity] == true) ? :hybrid : :conventional
                city_multiplier    = characteristics[:size_class].send(:"#{drivetrain}_fuel_efficiency_city_multiplier")
                highway_multiplier = characteristics[:size_class].send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
                
                if city_multiplier and highway_multiplier
                  1.0 / ((characteristics[:urbanity] / city_multiplier) + ((1.0 - characteristics[:urbanity]) / highway_multiplier))
                end
            end
            
            # Otherwise look up the average [size class](http://data.brighterplanet.com/automobile_size_classes) `hybridity` multipliers for city and highway fuel efficiency.
            # Calculate the harmonic mean of those multipliers, weighted by `urbanity`.
            quorum 'from hybridity and urbanity', :needs => [:hybridity, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                drivetrain = (characteristics[:hybridity] == true) ? :hybrid : :conventional
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
          # *True if the automobile is a hybrid vehicle. False if the automobile is a conventional vehicle.*
          #
          # Use client input, if available.
          
          #### Size class
          # *The automobile's [size class](http://data.brighterplanet.com/automobile_size_classes).*
          #
          # Use client input, if available.
          
          #### Urbanity (*%*)
          # *The fraction of the total distance driven that is in towns and cities rather than highways.*
          # Highways are defined as all driving at speeds of 45 miles per hour or greater.
          committee :urbanity do
            # Use the `safe country` average automobile urbanity (*%*).
            quorum 'from safe country', :needs => :safe_country,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:safe_country].automobile_urbanity
            end
          end
          
          #### Safe country
          # *Ensure that `country` has all needed values.*
          committee :safe_country do
            # Confirm that the client-input `country` has all the needed values.
            quorum 'from country', :needs => :country,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                if [:automobile_trip_distance, :automobile_city_speed, :automobile_highway_speed, :automobile_urbanity, :automobile_fuel_efficiency].all? { |required_attr| characteristics[:country].send(required_attr).present? }
                  characteristics[:country]
                end
            end
            
            # Otherwise use an artificial country that contains global averages.
            quorum 'default',
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do
                Country.fallback
            end
          end
          
          #### Country
          # *The [country](http://data.brighterplanet.com/countries) in which the trip occurred.*
          #
          # Use client input, if available.
          
          #### Make model year
          # *The automobile's [make, model, and year](http://data.brighterplanet.com/automobile_make_model_years).*
          committee :make_model_year do
            # Check whether the `make`, `model`, and `year` combination matches any automobiles in our database.
            # If it doesn't then we don't know `make model year`.
            quorum 'from make, model, and year', :needs => [:make, :model, :year],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileMakeModelYear.find_by_make_name_and_model_name_and_year(characteristics[:make].name, characteristics[:model].name, characteristics[:year].year)
            end
          end
          
          #### Make year
          # *The automobile's [make and year](http://data.brighterplanet.com/automobile_make_years).*
          committee :make_year do
            # Check whether the `make` and `year` combination matches any automobiles in our database.
            # If it doesn't then we don't know `make year`.
            quorum 'from make and year', :needs => [:make, :year],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileMakeYear.find_by_make_name_and_year(characteristics[:make].name, characteristics[:year].year)
            end
          end
          
          #### Make model
          # *The automobile's [make and model](http://data.brighterplanet.com/automobile_make_models).*
          committee :make_model do
            # Check whether the `make` and `model` combination matches any automobiles in our database.
            # If it doesn't then we don't know `make model`.
            quorum 'from make and model', :needs => [:make, :model],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileMakeModel.find_by_make_name_and_model_name(characteristics[:make].name, characteristics[:model].name)
            end
          end
          
          #### Year
          # *The automobile's [year of manufacture](http://data.brighterplanet.com/automobile_years).*
          #
          # Use client input, if available.
          
          #### Model
          # *The automobile's [model](http://data.brighterplanet.com/automobile_models).*
          #
          # Use client input, if available.
          
          #### Make
          # *The automobile's [make](http://data.brighterplanet.com/automobile_makes).*
          #
          # Use client input, if available.
          
          #### Date (*date*)
          # *The day the trip occurred.*
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
