Feature: Automobile Trip Emissions Calculations
  The automobile trip model should generate correct impact calculations

  Background:
    Given an automobile_trip

  Scenario: Calculations from nothing
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "4.72"
    And the amount of "energy" should be within "0.01" of "68.27"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Calculations from date
    Given it has "date" of "<date>"
    And it is the year "2010"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | date       | energy | carbon |
      | 2009-06-25 | 0.0    | 0.0    |
      | 2010-06-25 | 68.27  | 4.72   |
      | 2011-06-25 | 0.0    | 0.0    |

  Scenario Outline: Calculations from date and timeframe
    Given it has "date" of "<date>"
    And it has "timeframe" of "<timeframe>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | date       | timeframe             | energy | carbon |
      | 2009-06-25 | 2009-01-01/2009-01-31 | 0.0    | 0.0    |
      | 2009-06-25 | 2009-01-01/2009-12-31 | 68.27  | 4.72   |
      | 2009-06-25 | 2009-12-01/2009-12-31 | 0.0    | 0.0    |

  Scenario: Calculations from country
    Given it has "country.iso_3166_code" of "US"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "3.89"
    And the amount of "energy" should be within "0.01" of "56.16"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Calculations from hybridity and urbanity
    Given it has "urbanity" of "0.5"
    And it has "hybridity" of "<hybridity>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | energy | carbon |
      | true      | 48.81  | 3.38   |
      | false     | 68.85  | 4.76   |

  Scenario Outline: Calculations from size class, urbanity, and hybridity
    Given it has "size_class.name" of "Midsize Car"
    And it has "urbanity" of "0.5"
    And it has "hybridity" of "<hybridity>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | energy | carbon |
      | true      | 38.02  | 2.63   |
      | false     | 68.25  | 4.72   |

  Scenario Outline: Calculations from make and urbanity
    Given it has "urbanity" of "0.5"
    And it has "make.name" of "<make>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make   | energy | carbon |
      | Toyota | 44.93  | 3.11   |
      | Ford   | 56.16  | 3.89   |

  Scenario Outline: Calculations from make year and urbanity
    Given it has "urbanity" of "0.5"
    And it has "make.name" of "<make>"
    And it has "year.year" of "<year>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make   | year | energy | carbon |
      | Toyota | 2003 | 46.80  | 3.24   |
      | Ford   | 2010 | 48.83  | 3.38   |
      | Toyota | 2010 | 44.93  | 3.11   |
      | Ford   | 2003 | 56.16  | 3.89   |

  Scenario Outline: Calculations from make model and urbanity
    Given it has "urbanity" of "0.5"
    And it has "make.name" of "<make>"
    And it has "model.name" of "<model>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make   | model | energy | carbon |
      | Toyota | Prius | 28.08  | 1.94   |
      | Ford   | Focus | 46.80  | 3.24   |
      | Toyota | Focus | 44.93  | 3.11   |
      | Ford   | Prius | 56.16  | 3.89   |

  Scenario Outline: Calculations from make model year and urbanity
    Given it has "urbanity" of "0.5"
    And it has "make.name" of "<make>"
    And it has "model.name" of "<model>"
    And it has "year.year" of "<year>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make       | model | year | energy | carbon |
      | Toyota     | Prius | 2003 | 31.11  | 2.14   |
      | Ford       | Focus | 2010 | 53.49  | 3.88   |
      | Volkswagen | Jetta | 2011 | 47.73  | 3.10   |
      | Toyota     | Prius | 2010 | 28.08  | 1.94   |

  Scenario: Calculations from speed and duration
    Given it has "speed" of "5.0"
    And it has "duration" of "7200.0"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "2.95"
    And the amount of "energy" should be within "0.01" of "42.67"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Calculations from driveable locations
    Given it has "origin" of "44,-73.15"
    And the geocoder will encode the origin as "44,-73.15"
    And it has "destination" of "44.1,-73.15"
    And the geocoder will encode the destination as "44.1,-73.15"
    And mapquest determines the distance in miles to be "8.142"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "3.87"
    And the amount of "energy" should be within "0.01" of "55.91"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Calculations from non-driveable locations
    Given it has "origin" of "Los Angeles, CA"
    And the geocoder will encode the origin as "34.0522342,-118.2436849"
    And it has "destination" of "London, UK"
    And the geocoder will encode the destination as "51.5001524,-0.1262362"
    And mapquest determines the distance in miles to be ""
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "4.72"
    And the amount of "energy" should be within "0.01" of "68.27"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario: Calculations from fuel efficiency and distance
    Given it has "fuel_efficiency" of "10.0"
    And it has "distance" of "100.0"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "24.29"
    And the amount of "energy" should be within "0.01" of "351.00"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Calculations from fuel use and fuel
    Given it has "fuel_use" of "10.0"
    And it has "automobile_fuel.name" of "<fuel>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | fuel             | energy | carbon |
      | regular gasoline | 350.00 | 24.11  |
      | diesel           | 390.00 | 28.27  |
      | B20              | 358.00 | 23.27  |

  Scenario Outline: Calculations from fuel efficiency, distance, and fuel
    Given it has "fuel_efficiency" of "10.0"
    And it has "distance" of "100.0"
    And it has "automobile_fuel.name" of "<fuel>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | fuel             | energy | carbon |
      | regular gasoline | 350.00 | 24.11  |
      | diesel           | 390.00 | 28.27  |
      | B20              | 358.00 | 23.27  |
