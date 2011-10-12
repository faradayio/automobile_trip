Feature: Automobile Trip Committee Calculations
  The automobile trip model should generate correct committee calculations
  
  Background:
    Given an automobile_trip

  Scenario: Date committee from timeframe
    Given a characteristic "timeframe" of "2009-06-06/2010-01-01"
    When the "date" committee reports
    Then the committee should have used quorum "from timeframe"
    And the conclusion of the committee should be "2009-06-06"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Country committee from default
    When the "country" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should have "name" of "fallback"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Urbanity committee from default country
    When the "country" committee reports
    And the "urbanity" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "0.43"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Urbanity committee from country
    Given a characteristic "country.iso_3166_code" of "US"
    When the "urbanity" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "0.43"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Hybridity multiplier committee from default
    When the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "1.0"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Hybridity multiplier committee from hybridity and urbanity
    Given a characteristic "hybridity" of "<hybridity>"
    When the "country" committee reports
    And the "urbanity" committee reports
    And the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "from hybridity and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | multiplier |
      | true      | 1.36919    |
      | false     | 0.99211    |

  Scenario Outline: Hybridity multiplier committee from size class missing hybridity multipliers
    Given a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "country" committee reports
    And the "urbanity" committee reports
    And the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "from hybridity and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | size_class    | multiplier |
      | true      | Midsize Wagon | 1.36919    |
      | false     | Midsize Wagon | 0.99211    |

  Scenario Outline: Hybridity multiplier committee from size class with hybridity multipliers
    Given a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "country" committee reports
    And the "urbanity" committee reports
    And the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "from size class, hybridity, and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | size_class  | multiplier |
      | true      | Midsize Car | 1.68067    |
      | false     | Midsize Car | 0.87464    |

  Scenario Outline: Fuel efficiency committee from hybridity multiplier and default country
    Given a characteristic "hybridity_multiplier" of "<multiplier>"
    When the "country" committee reports
    And the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from hybridity multiplier and country"
    And the conclusion of the committee should be "<fe>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | multiplier | fe       |
      | 1.0        |  8.22653 |
      | 10         | 82.26531 |

  Scenario Outline: Fuel efficiency committee from hybridity multiplier and country
    Given a characteristic "hybridity_multiplier" of "<multiplier>"
    And a characteristic "country.iso_3166_code" of "US"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from hybridity multiplier and country"
    And the conclusion of the committee should be "<fe>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | multiplier | fe   |
      | 1.0        |  9.0 |
      | 10         | 90.0 |

  Scenario: Fuel efficiency committee from make and hybridity multiplier
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "hybridity_multiplier" of "2.0"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make and hybridity multiplier"
    And the conclusion of the committee should be "20.0"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Fuel efficiency committee from make year and hybridity multiplier
    Given a characteristic "make_year.name" of "Toyota 2003"
    And a characteristic "hybridity_multiplier" of "2.0"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make year and hybridity multiplier"
    And the conclusion of the committee should be "30.0"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Fuel efficiency committee from size class, hybridity multiplier, and urbanity
    Given a characteristic "size_class.name" of "Midsize Car"
    And a characteristic "hybridity_multiplier" of "2.0"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from size class, hybridity multiplier, and urbanity"
    And the conclusion of the committee should be "26.66667"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Fuel efficiency committee from make model and urbanity
    Given a characteristic "make_model.name" of "Toyota Prius"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make model and urbanity"
    And the conclusion of the committee should be "24.0"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Fuel efficiency committee from make model year and urbanity
    Given a characteristic "make_model_year.name" of "Toyota Prius 2003"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make model year and urbanity"
    And the conclusion of the committee should be "34.28571"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Fuel efficiency committee from make model year variant and urbanity
    Given a characteristic "make_model_year_variant.row_hash" of "xxx1"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make model year variant and urbanity"
    And the conclusion of the committee should be "44.44444"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Speed committee from default urbanity and country
    When the "country" committee reports
    And the "urbanity" committee reports
    And the "speed" committee reports
    Then the committee should have used quorum "from urbanity and country"
    And the conclusion of the committee should be "50.93426"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Speed committee from urbanity and country
    Given a characteristic "country.iso_3166_code" of "US"
    When the "urbanity" committee reports
    And the "speed" committee reports
    Then the committee should have used quorum "from urbanity and country"
    And the conclusion of the committee should be "50.93426"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Origin location from geocodeable origin
    Given a characteristic "origin" of address value "<origin>"
    And the geocoder will encode the origin as "<geocode>"
    When the "origin_location" committee reports
    Then the committee should have used quorum "from origin"
    And the conclusion of the committee should have "ll" of "<location>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | origin            | geocode                 | location                |
      | 05753             | 44.0229305,-73.1450146  | 44.0229305,-73.1450146  |
      | San Francisco, CA | 37.7749295,-122.4194155 | 37.7749295,-122.4194155 |
      | Los Angeles, CA   | 34.0522342,-118.2436849 | 34.0522342,-118.2436849 |
      | London, UK        | 51.5001524,-0.1262362   | 51.5001524,-0.1262362   |

  Scenario: Origin location from non-geocodeable origin
    Given a characteristic "origin" of "Bag End, Hobbiton, Westfarthing, The Shire, Eriador, Middle Earth"
    And the geocoder will fail to encode the origin
    When the "origin_location" committee reports
    Then the conclusion of the committee should be nil

  Scenario Outline: Destination location from geocodeable destination
    Given a characteristic "destination" of address value "<destination>"
    And the geocoder will encode the destination as "<geocode>"
    When the "destination_location" committee reports
    Then the committee should have used quorum "from destination"
    And the conclusion of the committee should have "ll" of "<location>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | destination       | geocode                 | location                |
      | 05753             | 44.0229305,-73.1450146  | 44.0229305,-73.1450146  |
      | San Francisco, CA | 37.7749295,-122.4194155 | 37.7749295,-122.4194155 |
      | Los Angeles, CA   | 34.0522342,-118.2436849 | 34.0522342,-118.2436849 |
      | London, UK        | 51.5001524,-0.1262362   | 51.5001524,-0.1262362   |

  Scenario: Destination location from non-geocodeable destination
    Given a characteristic "destination" of "Bag End, Hobbiton, Westfarthing, The Shire, Eriador, Middle Earth"
    And the geocoder will fail to encode the destination
    When the "destination_location" committee reports
    Then the conclusion of the committee should be nil

  Scenario: Distance committee from default country
    When the "country" committee reports
    And the "distance" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "16.0"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Distance committee from country
    Given a characteristic "country.iso_3166_code" of "US"
    When the "distance" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "16.0"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Distance committee from duration and speed
    Given a characteristic "duration" of "7200.0"
    And a characteristic "speed" of "5.0"
    When the "distance" committee reports
    Then the committee should have used quorum "from duration and speed"
    And the conclusion of the committee should be "10.0"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Distance committee from origin and destination locations
    Given a characteristic "origin" of address value "<origin>"
    And the geocoder will encode the origin as "origin"
    And a characteristic "destination" of address value "<destination>"
    And the geocoder will encode the destination as "destination"
    And mapquest determines the distance in miles to be "<mapquest_distance>"
    When the "origin_location" committee reports
    And the "destination_location" committee reports
    When the "distance" committee reports
    Then the committee should have used quorum "from origin and destination locations"
    And the conclusion of the committee should be "<distance>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
    | origin       | destination  | mapquest_distance | distance  |
    | 44.0,-73.15  | 44.0,-73.15  | 0.0               | 0.0       |
    | 44.0,-73.15  | 44.1,-73.15  | 8.142             | 13.10328  |

  Scenario: Distance commitee from undriveable origin and destination locations
    Given a characteristic "origin" of "San Francisco, CA"
    And the geocoder will encode the origin as "origin"
    And a characteristic "destination" of "London, UK"
    And the geocoder will encode the destination as "destination"
    And mapquest determines the route to be undriveable
    When the "country" committee reports
    And the "origin_location" committee reports
    And the "destination_location" committee reports
    And the "distance" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "16.0"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Fuel use committee from fuel efficiency and distance
    Given a characteristic "fuel_efficiency" of "10.0"
    And a characteristic "distance" of "100.0"
    When the "fuel_use" committee reports
    Then the committee should have used quorum "from fuel efficiency and distance"
    And the conclusion of the committee should be "10.0"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Automobile fuel committee from default
    When the "automobile_fuel" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should have "name" of "fallback"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Automobile fuel committee from make model year variant
    Given a characteristic "make_model_year_variant.row_hash" of "xxx1"
    When the "automobile_fuel" committee reports
    Then the committee should have used quorum "from make model year variant"
    And the conclusion of the committee should have "name" of "diesel"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: HFC emission factor committee from default automobile fuel
    When the "automobile_fuel" committee reports
    And the "hfc_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "0.10627"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: HFC emission factor committee from automobile fuel
    Given a characteristic "automobile_fuel.name" of "<fuel>"
    When the "hfc_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | fuel             | ef   |
      | regular gasoline | 0.1  |
      | diesel           | 0.12 |
      | B20              | 0.12 |

  Scenario: N2O emission factor committee from default automobile fuel
    When the "automobile_fuel" committee reports
    And the "n2o_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "0.00705"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: N2O emission factor committee from automobile fuel
    Given a characteristic "automobile_fuel.name" of "<fuel>"
    When the "n2o_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | fuel             | ef    |
      | regular gasoline | 0.008 |
      | diesel           | 0.002 |
      | B20              | 0.002 |

  Scenario: CH4 emission factor committee from default automobile fuel
    When the "automobile_fuel" committee reports
    And the "ch4_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "0.00226"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: CH4 emission factor committee from automobile fuel
    Given a characteristic "automobile_fuel.name" of "<fuel>"
    When the "ch4_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | fuel             | ef     |
      | regular gasoline | 0.002  |
      | diesel           | 0.0001 |
      | B20              | 0.0001 |

  Scenario: CO2 biogenic emission factor committee from default automobile fuel
    When the "automobile_fuel" committee reports
    And the "co2_biogenic_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "0.0"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: CO2 biogenic emission factor committee from automobile fuel
    Given a characteristic "automobile_fuel.name" of "<fuel>"
    When the "co2_biogenic_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | fuel             | ef  |
      | regular gasoline | 0.0 |
      | diesel           | 0.0 |
      | B20              | 0.5 |

  Scenario: CO2 emission factor committee from default automobile fuel
    When the "automobile_fuel" committee reports
    And the "co2_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "2.30958"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: CO2 emission factor committee from automobile fuel
    Given a characteristic "automobile_fuel.name" of "<fuel>"
    When the "co2_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | fuel             | ef  |
      | regular gasoline | 2.3 |
      | diesel           | 2.7 |
      | B20              | 2.2 |

  Scenario Outline: HFC emission from fuel use, hfc emission factor, date, and timeframe
    Given a characteristic "fuel_use" of "<fuel_use>"
    And a characteristic "hfc_emission_factor" of "<ef>"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "hfc_emission" committee reports
    Then the committee should have used quorum "from fuel use, hfc emission factor, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | fuel_use | ef  | date       | timeframe             | emission |
      | 10.0     | 2.0 | 2010-06-01 | 2010-01-01/2011-01-01 | 20.0     |
      | 10.0     | 2.0 | 2009-06-01 | 2010-01-01/2011-01-01 | 0.0      |

  Scenario Outline: N2O emission from fuel use, n2o emission factor, date, and timeframe
    Given a characteristic "fuel_use" of "<fuel_use>"
    And a characteristic "n2o_emission_factor" of "<ef>"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "n2o_emission" committee reports
    Then the committee should have used quorum "from fuel use, n2o emission factor, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | fuel_use | ef  | date       | timeframe             | emission |
      | 10.0     | 2.0 | 2010-06-01 | 2010-01-01/2011-01-01 | 20.0     |
      | 10.0     | 2.0 | 2009-06-01 | 2010-01-01/2011-01-01 | 0.0      |

  Scenario Outline: CH4 emission from fuel use, ch4 emission factor, date, and timeframe
    Given a characteristic "fuel_use" of "<fuel_use>"
    And a characteristic "ch4_emission_factor" of "<ef>"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "ch4_emission" committee reports
    Then the committee should have used quorum "from fuel use, ch4 emission factor, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | fuel_use | ef  | date       | timeframe             | emission |
      | 10.0     | 2.0 | 2010-06-01 | 2010-01-01/2011-01-01 | 20.0     |
      | 10.0     | 2.0 | 2009-06-01 | 2010-01-01/2011-01-01 | 0.0      |

  Scenario Outline: CO2 biogenic emission from fuel use, co2 biogenic emission factor, date, and timeframe
    Given a characteristic "fuel_use" of "<fuel_use>"
    And a characteristic "co2_biogenic_emission_factor" of "<ef>"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "co2_biogenic_emission" committee reports
    Then the committee should have used quorum "from fuel use, co2 biogenic emission factor, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | fuel_use | ef  | date       | timeframe             | emission |
      | 10.0     | 2.0 | 2010-06-01 | 2010-01-01/2011-01-01 | 20.0     |
      | 10.0     | 2.0 | 2009-06-01 | 2010-01-01/2011-01-01 | 0.0      |

  Scenario Outline: CO2 emission from fuel use, co2 emission factor, date, and timeframe
    Given a characteristic "fuel_use" of "<fuel_use>"
    And a characteristic "co2_emission_factor" of "<ef>"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "co2_emission" committee reports
    Then the committee should have used quorum "from fuel use, co2 emission factor, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | fuel_use | ef  | date       | timeframe             | emission |
      | 10.0     | 2.0 | 2010-06-01 | 2010-01-01/2011-01-01 | 20.0     |
      | 10.0     | 2.0 | 2009-06-01 | 2010-01-01/2011-01-01 | 0.0      |
