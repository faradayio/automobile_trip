Feature: Automobile Trip Emissions Calculations
  The automobile trip model should generate correct impact calculations

  Background:
    Given an automobile_trip

  Scenario: Calculations from nothing
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "4.72"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Calculations from date
    Given it has "date" of "<date>"
    And it is the year "2010"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<impact>"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | date       | impact |
      | 2009-06-25 | 0.0      |
      | 2010-06-25 | 4.72     |
      | 2011-06-25 | 0.0      |

  Scenario Outline: Calculations from date and timeframe
    Given it has "date" of "<date>"
    And it has "timeframe" of "<timeframe>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<impact>"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | date       | timeframe             | impact |
      | 2009-06-25 | 2009-01-01/2009-01-31 | 0.0      |
      | 2009-06-25 | 2009-01-01/2009-12-31 | 4.72     |
      | 2009-06-25 | 2009-12-01/2009-12-31 | 0.0      |

  Scenario: Calculations from country
    Given it has "country.iso_3166_code" of "US"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "4.31"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Calculations from urbanity
    Given it has "urbanity" of "0.5"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "4.72"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Calculations from hybridity and urbanity
    Given it has "hybridity" of "<hybridity>"
    And it has "urbanity" of "0.5"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<impact>"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | impact |
      | true      | 3.37     |
      | false     | 4.76     |

  Scenario: Calculations from make and urbanity
    Given it has "urbanity" of "0.5"
    And it has "make.name" of "Toyota"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "3.88"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Calculations from make, hybridity and urbanity
    Given it has "hybridity" of "<hybridity>"
    And it has "urbanity" of "0.5"
    And it has "make.name" of "Toyota"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<impact>"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | impact |
      | true      | 2.77     |
      | false     | 3.91     |

  Scenario: Calculations from make year and urbanity
    Given it has "urbanity" of "0.5"
    And it has "make_year.name" of "Toyota 2003"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "2.59"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Calculations from make year, hybridity and urbanity
    Given it has "hybridity" of "<hybridity>"
    And it has "urbanity" of "0.5"
    And it has "make_year.name" of "Toyota 2003"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<impact>"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | impact |
      | true      | 1.85     |
      | false     | 2.61     |

  Scenario: Calculations from size class and urbanity
    Given it has "urbanity" of "0.5"
    And it has "size_class.name" of "Midsize Car"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "2.91"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Calculations from size class, hybridity, and urbanity
    Given it has "hybridity" of "<hybridity>"
    And it has "urbanity" of "0.5"
    And it has "size_class.name" of "Midsize Car"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<impact>"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | impact |
      | true      | 1.70     |
      | false     | 3.40     |

  Scenario: Calculations from make model and urbanity
    Given it has "urbanity" of "0.5"
    And it has "make_model.name" of "Toyota Prius"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "1.62"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Calculations from make model year and urbanity
    Given it has "urbanity" of "0.5"
    And it has "make_model_year.name" of "Toyota Prius 2003"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "1.13"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Calculations from make model year variant and urbanity
    Given it has "urbanity" of "0.5"
    And it has "make_model_year_variant.row_hash" of "xxx1"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "1.02"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Calculations from speed and duration
    Given it has "speed" of "5.0"
    And it has "duration" of "7200.0"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "2.95"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Calculations from driveable locations
    Given it has "origin" of "44,-73.15"
    And the geocoder will encode the origin as "44,-73.15"
    And it has "destination" of "44.1,-73.15"
    And the geocoder will encode the destination as "44.1,-73.15"
    And mapquest determines the distance in miles to be "8.142"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "3.86"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Calculations from non-driveable locations
    Given it has "origin" of "Los Angeles, CA"
    And the geocoder will encode the origin as "34.0522342,-118.2436849"
    And it has "destination" of "London, UK"
    And the geocoder will encode the destination as "51.5001524,-0.1262362"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "4.72"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Calculations from fuel efficiency and distance
    Given it has "fuel_efficiency" of "10.0"
    And it has "distance" of "100.0"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "24.25"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Calculations from fuel use and fuel
    Given it has "fuel_use" of "20.0"
    And it has "automobile_fuel.name" of "<fuel>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<impact>"
    And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | fuel             | impact |
      | regular gasoline | 48.20    |
      | diesel           | 56.44    |
      | B20              | 46.44    |
