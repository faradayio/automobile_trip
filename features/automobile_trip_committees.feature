Feature: Automobile Trip Committee Calculations
  The automobile trip model should generate correct committee calculations
  
  Background:
    Given an automobile_trip

  Scenario: Date committee from timeframe
    Given a characteristic "timeframe" of "2009-06-06/2010-01-01"
    When the "date" committee reports
    Then the committee should have used quorum "from timeframe"
    And the conclusion of the committee should be "2009-06-06"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario Outline: Make model committee from valid make model combination
    Given a characteristic "make.name" of "<make>"
    And a characteristic "model.name" of "<model>"
    When the "make_model" committee reports
    Then the committee should have used quorum "from make and model"
    And the conclusion of the committee should have "name" of "<make_model>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | make   | model | make_model   |
      | Toyota | Prius | Toyota Prius |
      | Ford   | Focus | Ford Focus   |

  Scenario Outline: Make model committee from invalid make model combination
    Given a characteristic "make.name" of "<make>"
    And a characteristic "model.name" of "<model>"
    When the "make_model" committee reports
    Then the conclusion of the committee should be nil
    Examples:
      | make   | model |
      | Toyota | Focus |
      | Ford   | Prius |

  Scenario: Make year committee from valid make year combination
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "year.year" of "2003"
    When the "make_year" committee reports
    Then the committee should have used quorum "from make and year"
    And the conclusion of the committee should have "name" of "Toyota 2003"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: Make year committee from invalid make year combination
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "year.year" of "2010"
    When the "make_year" committee reports
    Then the conclusion of the committee should be nil

  Scenario: Make model year committee from valid make model year combination
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "model.name" of "Prius"
    And a characteristic "year.year" of "2003"
    When the "make_model_year" committee reports
    Then the committee should have used quorum "from make, model, and year"
    And the conclusion of the committee should have "name" of "Toyota Prius 2003"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: Make model year committee from invalid make model year combination
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "model.name" of "Focus"
    And a characteristic "year.year" of "2003"
    When the "make_model_year" committee reports
    Then the conclusion of the committee should be nil

  Scenario: Country committee from default
    When the "country" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should have "name" of "fallback"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: Urbanity committee from default country
    When the "country" committee reports
    And the "urbanity" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "0.4"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: Urbanity committee from country
    Given a characteristic "country.iso_3166_code" of "US"
    When the "urbanity" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "0.4"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: Hybridity multiplier committee from default
    When the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "1.0"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario Outline: Hybridity multiplier committee from hybridity and urbanity
    Given a characteristic "hybridity" of "<hybridity>"
    When the "country" committee reports
    And the "urbanity" committee reports
    And the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "from hybridity and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | multiplier |
      | true      | 1.35700    |
      | false     | 0.99238    |

  Scenario Outline: Hybridity multiplier committee from size class missing hybridity multipliers
    Given a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "country" committee reports
    And the "urbanity" committee reports
    And the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "from hybridity and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | size_class    | multiplier |
      | true      | Midsize Wagon | 1.35700    |
      | false     | Midsize Wagon | 0.99238    |

  Scenario Outline: Hybridity multiplier committee from size class with hybridity multipliers
    Given a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "country" committee reports
    And the "urbanity" committee reports
    And the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "from size class, hybridity, and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | size_class  | multiplier |
      | true      | Midsize Car | 1.47059    |
      | false     | Midsize Car | 0.88235    |

  Scenario: Fuel efficiency committee from defaults
    When the "country" committee reports
    And the "hybridity_multiplier" committee reports
    And the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from hybridity multiplier and country"
    And the conclusion of the committee should be "8.22653"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Fuel efficiency committee country and hybridity multiplier
    Given a characteristic "country.iso_3166_code" of "US"
    And a characteristic "hybridity_multiplier" of "2.0"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from hybridity multiplier and country"
    And the conclusion of the committee should be "20.0"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Fuel efficiency committee from make and hybridity multiplier
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "hybridity_multiplier" of "2.0"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make and hybridity multiplier"
    And the conclusion of the committee should be "25.0"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Fuel efficiency committee from make year and hybridity multiplier
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "year.year" of "2003"
    And a characteristic "hybridity_multiplier" of "2.0"
    When the "make_year" committee reports
    And the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make year and hybridity multiplier"
    And the conclusion of the committee should be "24.0"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Fuel efficiency committee from size class, hybridity multiplier, and urbanity
    Given a characteristic "size_class.name" of "Midsize Car"
    And a characteristic "hybridity_multiplier" of "2.0"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from size class, hybridity multiplier, and urbanity"
    And the conclusion of the committee should be "19.2"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Fuel efficiency committee from make model and urbanity
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "model.name" of "Prius"
    And a characteristic "urbanity" of "0.5"
    When the "make_model" committee reports
    And the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make model and urbanity"
    And the conclusion of the committee should be "20.0"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: Fuel efficiency committee from make model year and urbanity
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "model.name" of "Prius"
    And a characteristic "year.year" of "2003"
    And a characteristic "urbanity" of "0.5"
    When the "make_model_year" committee reports
    And the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make model year and urbanity"
    And the conclusion of the committee should be "18.0"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: Speed committee from default urbanity and default country
    When the "country" committee reports
    And the "urbanity" committee reports
    And the "speed" committee reports
    Then the committee should have used quorum "from urbanity and country"
    And the conclusion of the committee should be "50.0"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: Speed committee from urbanity and country
    Given a characteristic "country.iso_3166_code" of "US"
    When the "urbanity" committee reports
    And the "speed" committee reports
    Then the committee should have used quorum "from urbanity and country"
    And the conclusion of the committee should be "50.0"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario Outline: Origin location from geocodeable origin
    Given a characteristic "origin" of address value "<origin>"
    And the geocoder will encode the origin as "<geocode>"
    When the "origin_location" committee reports
    Then the committee should have used quorum "from origin"
    And the conclusion of the committee should have "ll" of "<location>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
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
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
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

  Scenario Outline: Fuel use committee from fuel efficiency, distance, date, and timeframe
    Given a characteristic "fuel_efficiency" of "10.0"
    And a characteristic "distance" of "100.0"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "fuel_use" committee reports
    Then the committee should have used quorum "from fuel efficiency, distance, date, and timeframe"
    And the conclusion of the committee should be "<fuel_use>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | date       | timeframe             | fuel_use |
      | 2010-06-01 | 2010-01-01/2011-01-01 | 10.0     |
      | 2009-06-01 | 2010-01-01/2011-01-01 | 0.0      |

  Scenario: Automobile fuel committee from default
    When the "automobile_fuel" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should have "name" of "fallback"
    And the conclusion of the committee should have "energy_content" of "35.09967"
    And the conclusion of the committee should have "co2_emission_factor" of "2.30997"
    And the conclusion of the committee should have "co2_biogenic_emission_factor" of "0.0"
    And the conclusion of the committee should have "ch4_emission_factor" of "0.00206"
    And the conclusion of the committee should have "n2o_emission_factor" of "0.00782"
    And the conclusion of the committee should have "hfc_emission_factor" of "0.10910"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Automobile fuel committee from make model year
    Given a characteristic "make.name" of "<make>"
    And a characteristic "model.name" of "<model>"
    And a characteristic "year.year" of "<year>"
    When the "make_model_year" committee reports
    And the "automobile_fuel" committee reports
    Then the committee should have used quorum "from make model year"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should have "name" of "<fuel>"
    Examples:
      | make       | model | year | fuel             |
      | Toyota     | Prius | 2003 | regular gasoline |
      | Ford       | Focus | 2010 | diesel           |
      | Volkswagen | Jetta | 2011 | B20              |

  Scenario: Energy use committee from fuel use and default automobile fuel
    Given a characteristic "fuel_use" of "1"
    When the "automobile_fuel" committee reports
    And the "energy" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards ""
    And the conclusion of the committee should be "35.09967"

  Scenario Outline: Energy use committee from default fuel use and automobile fuel
    Given a characteristic "fuel_use" of "1"
    And a characteristic "automobile_fuel.name" of "<fuel>"
    When the "energy" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards ""
    And the conclusion of the committee should be "<energy>"
    Examples:
      | fuel             | energy |
      | regular gasoline | 35.0   |
      | diesel           | 39.0   |
      | B20              | 35.8   |

  Scenario: HFC emission from fuel use and default automobile fuel
    Given a characteristic "fuel_use" of "10.0"
    When the "automobile_fuel" committee reports
    And the "hfc_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion of the committee should be "1.09104"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario Outline: HFC emission from fuel use and automobile fuel
    Given a characteristic "fuel_use" of "10.0"
    And a characteristic "automobile_fuel.name" of "<fuel>"
    When the "hfc_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion of the committee should be "<emission>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | fuel             | emission |
      | regular gasoline | 1.0      |
      | diesel           | 1.25     |
      | B20              | 1.25    |

  Scenario: N2O emission from fuel use and default automobile fuel
    Given a characteristic "fuel_use" of "10.0"
    When the "automobile_fuel" committee reports
    And the "n2o_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion of the committee should be "0.07821"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario Outline: N2O emission from fuel use and automobile fuel
    Given a characteristic "fuel_use" of "10.0"
    And a characteristic "automobile_fuel.name" of "<fuel>"
    When the "n2o_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion of the committee should be "<emission>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | fuel             | emission |
      | regular gasoline | 0.08     |
      | diesel           | 0.02     |
      | B20              | 0.02     |

  Scenario: CH4 emission from fuel use and default automobile fuel
    Given a characteristic "fuel_use" of "10.0"
    When the "automobile_fuel" committee reports
    And the "ch4_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion of the committee should be "0.02064"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario Outline: CH4 emission from fuel use and automobile fuel
    Given a characteristic "fuel_use" of "10.0"
    And a characteristic "automobile_fuel.name" of "<fuel>"
    When the "ch4_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion of the committee should be "<emission>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | fuel             | emission |
      | regular gasoline | 0.025    |
      | diesel           | 0.001    |
      | B20              | 0.001    |

  Scenario: CO2 biogenic emission from fuel use and default automobile fuel
    Given a characteristic "fuel_use" of "10.0"
    When the "automobile_fuel" committee reports
    And the "co2_biogenic_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion of the committee should be "0.0"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario Outline: CO2 biogenic emission from fuel use and automobile fuel
    Given a characteristic "fuel_use" of "10.0"
    And a characteristic "automobile_fuel.name" of "<fuel>"
    When the "co2_biogenic_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion of the committee should be "<emission>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | fuel             | emission |
      | regular gasoline | 0.0      |
      | diesel           | 0.0      |
      | B20              | 5.0      |

  Scenario: CO2 emission from fuel use and default automobile fuel
    Given a characteristic "fuel_use" of "10.0"
    When the "automobile_fuel" committee reports
    And the "co2_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion of the committee should be "23.09967"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario Outline: CO2 emission from fuel use and automobile fuel
    Given a characteristic "fuel_use" of "10.0"
    And a characteristic "automobile_fuel.name" of "<fuel>"
    When the "co2_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion of the committee should be "<emission>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | fuel             | emission |
      | regular gasoline | 23.0     |
      | diesel           | 27.0     |
      | B20              | 22.0     |

  Scenario: Carbon from co2 emission, ch4 emission, n2o emission, and hfc emission
    Given a characteristic "co2_emission" of "10.0"
    And a characteristic "ch4_emission" of "0.1"
    And a characteristic "n2o_emission" of "0.1"
    And a characteristic "hfc_emission" of "1.0"
    And a characteristic "date" of "2010-06-01"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "carbon" committee reports
    Then the committee should have used quorum "from co2 emission, ch4 emission, n2o emission, and hfc emission"
    And the conclusion of the committee should be "11.2"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
