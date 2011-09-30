Feature: Automobile Trip Committee Calculations
  The automobile trip model should generate correct committee calculations
  
  # FIXME TODO test for compliance
  
  Background:
    Given an automobile_trip emitter
  
  Scenario: Date committee from timeframe
    And a characteristic "timeframe" of "2009-06-06/2010-01-01"
    When the "date" committee is calculated
    Then the committee should have used quorum "from timeframe"
    And the conclusion of the committee should be "2009-06-06"

  Scenario: Country committee from default
    When the "country" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should have "name" of "fallback"

  Scenario: Urbanity committee from default country
    When the "country" committee is calculated
    And the "urbanity" committee is calculated
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "0.43"

  Scenario: Urbanity committee from country
    And a characteristic "country.iso_3166_code" of "US"
    When the "urbanity" committee is calculated
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "0.43"

  Scenario: Hybridity multiplier committee from default
    When the "hybridity_multiplier" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "1.0"

  Scenario Outline: Hybridity multiplier committee from hybridity and urbanity
    And a characteristic "hybridity" of "<hybridity>"
    When the "country" committee is calculated
    And the "urbanity" committee is calculated
    And the "hybridity_multiplier" committee is calculated
    Then the committee should have used quorum "from hybridity and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | multiplier |
      | true      | 1.36919    |
      | false     | 0.99211    |

  Scenario Outline: Hybridity multiplier committee from size class missing hybridity multipliers
    And a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "country" committee is calculated
    And the "urbanity" committee is calculated
    And the "hybridity_multiplier" committee is calculated
    Then the committee should have used quorum "from hybridity and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | size_class    | multiplier |
      | true      | Midsize Wagon | 1.36919    |
      | false     | Midsize Wagon | 0.99211    |

  Scenario Outline: Hybridity multiplier committee from size class with hybridity multipliers
    And a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "country" committee is calculated
    And the "urbanity" committee is calculated
    And the "hybridity_multiplier" committee is calculated
    Then the committee should have used quorum "from size class, hybridity, and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | size_class  | multiplier |
      | true      | Midsize Car | 1.68067    |
      | false     | Midsize Car | 0.87464    |

  Scenario Outline: Fuel efficiency committee from hybridity multiplier and default country
    And a characteristic "hybridity_multiplier" of "<multiplier>"
    When the "country" committee is calculated
    And the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from hybridity multiplier and country"
    And the conclusion of the committee should be "<fe>"
    Examples:
      | multiplier | fe       |
      | 1.0        |  8.22653 |
      | 10         | 82.26531 |

  Scenario Outline: Fuel efficiency committee from hybridity multiplier and country
    And a characteristic "hybridity_multiplier" of "<multiplier>"
    And a characteristic "country.iso_3166_code" of "US"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from hybridity multiplier and country"
    And the conclusion of the committee should be "<fe>"
    Examples:
      | multiplier | fe   |
      | 1.0        |  9.0 |
      | 10         | 90.0 |

  Scenario: Fuel efficiency committee from make and hybridity multiplier
    And a characteristic "make.name" of "Toyota"
    And a characteristic "hybridity_multiplier" of "2.0"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make and hybridity multiplier"
    And the conclusion of the committee should be "20.0"

  Scenario: Fuel efficiency committee from make year and hybridity multiplier
    And a characteristic "make_year.name" of "Toyota 2003"
    And a characteristic "hybridity_multiplier" of "2.0"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make year and hybridity multiplier"
    And the conclusion of the committee should be "30.0"

  Scenario: Fuel efficiency committee from size class, hybridity multiplier, and urbanity
    And a characteristic "size_class.name" of "Midsize Car"
    And a characteristic "hybridity_multiplier" of "2.0"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from size class, hybridity multiplier, and urbanity"
    And the conclusion of the committee should be "26.66667"

  Scenario: Fuel efficiency committee from make model and urbanity
    And a characteristic "make_model.name" of "Toyota Prius"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make model and urbanity"
    And the conclusion of the committee should be "24.0"

  Scenario: Fuel efficiency committee from make model year and urbanity
    And a characteristic "make_model_year.name" of "Toyota Prius 2003"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make model year and urbanity"
    And the conclusion of the committee should be "34.28571"

  Scenario: Fuel efficiency committee from make model year variant and urbanity
    And a characteristic "make_model_year_variant.row_hash" of "xxx1"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make model year variant and urbanity"
    And the conclusion of the committee should be "44.44444"

  Scenario: Speed committee from urbanity and default country
    When the "country" committee is calculated
    And the "urbanity" committee is calculated
    And the "speed" committee is calculated
    Then the committee should have used quorum "from urbanity and country"
    And the conclusion of the committee should be "50.93426"

  Scenario: Speed committee from urbanity and country
    And a characteristic "country.iso_3166_code" of "US"
    When the "urbanity" committee is calculated
    And the "speed" committee is calculated
    Then the committee should have used quorum "from urbanity and country"
    And the conclusion of the committee should be "50.93426"

  Scenario Outline: Origin location from geocodeable origin
    And a characteristic "origin" of address value "<origin>"
    And the geocoder will encode the origin as "<geocode>"
    When the "origin_location" committee is calculated
    Then the committee should have used quorum "from origin"
    And the conclusion of the committee should have "ll" of "<location>"
    Examples:
      | origin            | geocode                 | location                |
      | 05753             | 44.0229305,-73.1450146  | 44.0229305,-73.1450146  |
      | San Francisco, CA | 37.7749295,-122.4194155 | 37.7749295,-122.4194155 |
      | Los Angeles, CA   | 34.0522342,-118.2436849 | 34.0522342,-118.2436849 |
      | London, UK        | 51.5001524,-0.1262362   | 51.5001524,-0.1262362   |

  Scenario: Origin location from non-geocodeable origin
    And a characteristic "origin" of "Bag End, Hobbiton, Westfarthing, The Shire, Eriador, Middle Earth"
    And the geocoder will fail to encode the origin
    When the "origin_location" committee is calculated
    Then the conclusion of the committee should be nil

  Scenario Outline: Destination location from geocodeable destination
    And a characteristic "destination" of address value "<destination>"
    And the geocoder will encode the destination as "<geocode>"
    When the "destination_location" committee is calculated
    Then the committee should have used quorum "from destination"
    And the conclusion of the committee should have "ll" of "<location>"
    Examples:
      | destination       | geocode                 | location                |
      | 05753             | 44.0229305,-73.1450146  | 44.0229305,-73.1450146  |
      | San Francisco, CA | 37.7749295,-122.4194155 | 37.7749295,-122.4194155 |
      | Los Angeles, CA   | 34.0522342,-118.2436849 | 34.0522342,-118.2436849 |
      | London, UK        | 51.5001524,-0.1262362   | 51.5001524,-0.1262362   |

  Scenario: Destination location from non-geocodeable destination
    And a characteristic "destination" of "Bag End, Hobbiton, Westfarthing, The Shire, Eriador, Middle Earth"
    And the geocoder will fail to encode the destination
    When the "destination_location" committee is calculated
    Then the conclusion of the committee should be nil

  Scenario: Distance committee from default country
    When the "country" committee is calculated
    And the "distance" committee is calculated
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "16.0"

  Scenario: Distance committee from country
    And a characteristic "country.iso_3166_code" of "US"
    When the "distance" committee is calculated
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "16.0"

  Scenario: Distance committee from duration and speed
    And a characteristic "duration" of "7200.0"
    And a characteristic "speed" of "5.0"
    When the "distance" committee is calculated
    Then the committee should have used quorum "from duration and speed"
    And the conclusion of the committee should be "10.0"

  Scenario Outline: Distance committee from origin and destination locations
    And a characteristic "origin" of address value "<origin>"
    And the geocoder will encode the origin as "origin"
    And a characteristic "destination" of address value "<destination>"
    And the geocoder will encode the destination as "destination"
    And mapquest determines the distance in miles to be "<mapquest_distance>"
    When the "origin_location" committee is calculated
    And the "destination_location" committee is calculated
    When the "distance" committee is calculated
    Then the committee should have used quorum "from origin and destination locations"
    And the conclusion of the committee should be "<distance>"
    Examples:
    | origin       | destination  | mapquest_distance | distance  |
    | 44.0,-73.15  | 44.0,-73.15  | 0.0               | 0.0       |
    | 44.0,-73.15  | 44.1,-73.15  | 8.142             | 13.10328  |

  Scenario: Distance commitee from undriveable origin and destination locations
    And a characteristic "origin" of "Lansing, MI"
    And a characteristic "destination" of "London, UK"
    And mapquest determines the route to be undriveable
    When the "country" committee is calculated
    And the "origin_location" committee is calculated
    And the "destination_location" committee is calculated
    And the "distance" committee is calculated
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "16.0"

  Scenario: Fuel use committee from fuel efficiency and distance
    And a characteristic "fuel_efficiency" of "10.0"
    And a characteristic "distance" of "100.0"
    When the "fuel_use" committee is calculated
    Then the committee should have used quorum "from fuel efficiency and distance"
    And the conclusion of the committee should be "10.0"

  Scenario: Automobile fuel committee from default
    When the "automobile_fuel" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should have "name" of "fallback"

  Scenario: Automobile fuel committee from make model year variant
    And a characteristic "make_model_year_variant.row_hash" of "xxx1"
    When the "automobile_fuel" committee is calculated
    Then the committee should have used quorum "from make model year variant"
    And the conclusion of the committee should have "name" of "diesel"

  Scenario: HFC emission factor committee from default automobile fuel
    When the "automobile_fuel" committee is calculated
    And the "hfc_emission_factor" committee is calculated
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "0.10627"

  Scenario Outline: HFC emission factor committee from automobile fuel
    And a characteristic "automobile_fuel.name" of "<fuel>"
    When the "hfc_emission_factor" committee is calculated
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | fuel             | ef   |
      | regular gasoline | 0.1  |
      | diesel           | 0.12 |
      | B20              | 0.12 |

  Scenario: N2O emission factor committee from default automobile fuel
    When the "automobile_fuel" committee is calculated
    And the "n2o_emission_factor" committee is calculated
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "0.00705"

  Scenario Outline: N2O emission factor committee from automobile fuel
    And a characteristic "automobile_fuel.name" of "<fuel>"
    When the "n2o_emission_factor" committee is calculated
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | fuel             | ef    |
      | regular gasoline | 0.008 |
      | diesel           | 0.002 |
      | B20              | 0.002 |

  Scenario: CH4 emission factor committee from default automobile fuel
    When the "automobile_fuel" committee is calculated
    And the "ch4_emission_factor" committee is calculated
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "0.00226"

  Scenario Outline: CH4 emission factor committee from automobile fuel
    And a characteristic "automobile_fuel.name" of "<fuel>"
    When the "ch4_emission_factor" committee is calculated
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | fuel             | ef     |
      | regular gasoline | 0.002  |
      | diesel           | 0.0001 |
      | B20              | 0.0001 |

  Scenario: CO2 biogenic emission factor committee from default automobile fuel
    When the "automobile_fuel" committee is calculated
    And the "co2_biogenic_emission_factor" committee is calculated
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "0.0"

  Scenario Outline: CO2 biogenic emission factor committee from automobile fuel
    And a characteristic "automobile_fuel.name" of "<fuel>"
    When the "co2_biogenic_emission_factor" committee is calculated
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | fuel             | ef  |
      | regular gasoline | 0.0 |
      | diesel           | 0.0 |
      | B20              | 0.5 |

  Scenario: CO2 emission factor committee from default automobile fuel
    When the "automobile_fuel" committee is calculated
    And the "co2_emission_factor" committee is calculated
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "2.30958"

  Scenario Outline: CO2 emission factor committee from automobile fuel
    And a characteristic "automobile_fuel.name" of "<fuel>"
    When the "co2_emission_factor" committee is calculated
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | fuel             | ef  |
      | regular gasoline | 2.3 |
      | diesel           | 2.7 |
      | B20              | 2.2 |

  Scenario Outline: HFC emission from fuel use, hfc emission factor, date, and timeframe
    And a characteristic "fuel_use" of "<fuel_use>"
    And a characteristic "hfc_emission_factor" of "<ef>"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "hfc_emission" committee is calculated
    Then the committee should have used quorum "from fuel use, hfc emission factor, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | fuel_use | ef  | date       | timeframe             | emission |
      | 10.0     | 2.0 | 2010-06-01 | 2010-01-01/2011-01-01 | 20.0     |
      | 10.0     | 2.0 | 2009-06-01 | 2010-01-01/2011-01-01 | 0.0      |

  Scenario Outline: N2O emission from fuel use, n2o emission factor, date, and timeframe
    And a characteristic "fuel_use" of "<fuel_use>"
    And a characteristic "n2o_emission_factor" of "<ef>"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "n2o_emission" committee is calculated
    Then the committee should have used quorum "from fuel use, n2o emission factor, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | fuel_use | ef  | date       | timeframe             | emission |
      | 10.0     | 2.0 | 2010-06-01 | 2010-01-01/2011-01-01 | 20.0     |
      | 10.0     | 2.0 | 2009-06-01 | 2010-01-01/2011-01-01 | 0.0      |

  Scenario Outline: CH4 emission from fuel use, ch4 emission factor, date, and timeframe
    And a characteristic "fuel_use" of "<fuel_use>"
    And a characteristic "ch4_emission_factor" of "<ef>"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "ch4_emission" committee is calculated
    Then the committee should have used quorum "from fuel use, ch4 emission factor, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | fuel_use | ef  | date       | timeframe             | emission |
      | 10.0     | 2.0 | 2010-06-01 | 2010-01-01/2011-01-01 | 20.0     |
      | 10.0     | 2.0 | 2009-06-01 | 2010-01-01/2011-01-01 | 0.0      |

  Scenario Outline: CO2 biogenic emission from fuel use, co2 biogenic emission factor, date, and timeframe
    And a characteristic "fuel_use" of "<fuel_use>"
    And a characteristic "co2_biogenic_emission_factor" of "<ef>"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "co2_biogenic_emission" committee is calculated
    Then the committee should have used quorum "from fuel use, co2 biogenic emission factor, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | fuel_use | ef  | date       | timeframe             | emission |
      | 10.0     | 2.0 | 2010-06-01 | 2010-01-01/2011-01-01 | 20.0     |
      | 10.0     | 2.0 | 2009-06-01 | 2010-01-01/2011-01-01 | 0.0      |

  Scenario Outline: CO2 emission from fuel use, co2 emission factor, date, and timeframe
    And a characteristic "fuel_use" of "<fuel_use>"
    And a characteristic "co2_emission_factor" of "<ef>"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "co2_emission" committee is calculated
    Then the committee should have used quorum "from fuel use, co2 emission factor, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | fuel_use | ef  | date       | timeframe             | emission |
      | 10.0     | 2.0 | 2010-06-01 | 2010-01-01/2011-01-01 | 20.0     |
      | 10.0     | 2.0 | 2009-06-01 | 2010-01-01/2011-01-01 | 0.0      |
