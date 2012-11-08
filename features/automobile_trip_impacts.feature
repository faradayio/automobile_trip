Feature: Automobile Trip Emissions Calculations
  The automobile trip model should generate correct impact calculations

  Background:
    Given an automobile_trip

  Scenario: Calculations from nothing
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "4.74"
    And the amount of "energy" should be within "0.01" of "68.16"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Calculations from fuel use, date, and timeframe
    Given it has "fuel_use" of "100"
    And it has "date" of "<date>"
    And it is the year "<year>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | date       | year | energy  | carbon |
      | 2008-06-25 | 2008 | 3504.36 | 230.79 |
      | 2009-06-25 | 2009 | 3504.36 | 230.76 |
      | 2010-06-25 | 2010 | 3504.36 | 230.76 |
      | 2011-06-25 | 2010 |    0.0  |   0.0  |

  Scenario Outline: Calculations from country
    Given it has "country.iso_3166_code" of "<country>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | country | energy | carbon |
      | GB      | 68.16  | 4.75   |
      | US      | 56.07  | 3.95   |

  Scenario Outline: Calculations from hybridity
    Given it has "hybridity" of "<hybridity>"
    And it has "distance" of "100"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | energy | carbon |
      | true      | 296.83 | 21.16  |
      | false     | 429.97 | 29.91  |

  Scenario Outline: Calculations from size class, hybridity, and distance
    Given it has "size_class.name" of "Midsize Car"
    And it has "hybridity" of "<hybridity>"
    And it has "distance" of "100"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | energy | carbon |
      | true      | 251.47 | 17.87  |
      | false     | 471.51 | 32.35  |

  Scenario Outline: Calculations from make and distance
    Given it has "make.name" of "<make>"
    And it has "distance" of "100"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make   | energy | carbon |
      | Toyota | 280.35 | 20.07  |
      | Ford   | 318.58 | 22.59  |

  Scenario Outline: Calculations from make year and distance
    Given it has "make.name" of "<make>"
    And it has "year.year" of "<year>"
    And it has "distance" of "100"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make   | year | energy | carbon |
      | Toyota | 2003 | 292.03 | 20.84  |
      | Ford   | 2012 | 350.44 | 24.68  |
      | Toyota | 2012 | 280.35 | 20.07  |
      | Ford   | 2003 | 318.58 | 22.59  |

  Scenario Outline: Calculations from make model, urbanity, and distance
    Given it has "urbanity" of "0.5"
    And it has "distance" of "100"
    And it has "make.name" of "<make>"
    And it has "model.name" of "<model>"
    And it has "automobile_fuel.code" of "<fuel>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make       | model     | fuel | energy | carbon |
      | Toyota     | Prius     |      | 179.61 | 13.04  |
      | Ford       | F150 FFV  |      | 510.42 | 35.84  |
      | Chevrolet  | Volt      |      | 219.61 | 15.67  |
      | Nissan     | Leaf      |      |  83.76 | 15.27  |
      | Volkswagen | Jetta     |      | 340.28 | 23.60  |
      | Volkswagen | Jetta     | D    | 255.02 | 18.61  |
      | Honda      | Civic CNG |      | 284.09 | 16.90  |
      | Honda      | FCX       |      | 134.62 |  0.70  |

  Scenario Outline: Calculations from make model year, urbanity, and distance
    Given it has "urbanity" of "0.5"
    And it has "distance" of "100"
    And it has "make.name" of "<make>"
    And it has "model.name" of "<model>"
    And it has "year.year" of "<year>"
    And it has "automobile_fuel.code" of "<fuel>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make       | model     | year | fuel | energy | carbon |
      | Toyota     | Prius     | 2003 |      | 200.16 | 14.12  |
      | Ford       | F150 FFV  | 2012 |      | 444.44 | 30.83  |
      | Chevrolet  | Volt      | 2012 |      | 219.61 | 15.45  |
      | Nissan     | Leaf      | 2012 |      |  83.76 | 15.27  |
      | Volkswagen | Jetta     | 2003 |      | 364.58 | 24.93  |
      | Volkswagen | Jetta     | 2003 | D    | 244.44 | 17.86  |
      | Honda      | Civic CNG | 2003 |      | 293.71 | 17.39  |
      | Honda      | FCX       | 2010 |      | 134.62 |  0.70  |

  Scenario: Calculations from speed and duration
    Given it has "speed" of "5.0"
    And it has "duration" of "7200.0"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "2.97"
    And the amount of "energy" should be within "0.01" of "42.60"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
  
  Scenario: Calculations from driveable locations
    Given it has "origin" of "44,-73.15"
    And the geocoder will encode the origin as "44,-73.15"
    And it has "destination" of "44.1,-73.15"
    And the geocoder will encode the destination as "44.1,-73.15"
    And mapquest determines the distance in miles to be "8"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "3.82"
    And the amount of "energy" should be within "0.01" of "54.84"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
  
  Scenario: Calculations from non-driveable locations
    Given it has "origin" of "Los Angeles, CA"
    And the geocoder will encode the origin as "34.0522342,-118.2436849"
    And it has "destination" of "London, UK"
    And the geocoder will encode the destination as "51.5001524,-0.1262362"
    And mapquest determines the distance in miles to be ""
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "4.75"
    And the amount of "energy" should be within "0.01" of "68.16"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
  
  Scenario: Calculations from fuel efficiency and distance
    Given it has "fuel_efficiency" of "10.0"
    And it has "distance" of "100.0"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "24.69"
    And the amount of "energy" should be within "0.01" of "350.44"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
  
  Scenario Outline: Calculations from fuel use and fuel
    Given it has "fuel_use" of "10.0"
    And it has "automobile_fuel.code" of "<fuel>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | fuel   | energy | carbon |
      | G      | 350.0  | 23.26  |
      | R      | 350.0  | 23.26  |
      | P      | 350.0  | 23.26  |
      | D      | 385.0  | 27.16  |
      | BP-B20 | 380.0  | 22.16  |
      | E      | 250.0  |  4.34  |
      | C      | 380.0  | 19.48  |
      | EL     |  36.0  |  6.42  |
      | H      |1200.0  |  0.16  |
  
  Scenario Outline: Calculations from fuel efficiency, distance, and fuel
    Given it has "fuel_efficiency" of "10.0"
    And it has "distance" of "100.0"
    And it has "automobile_fuel.code" of "<fuel>"
    When impacts are calculated
    # Then trace the calculation
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | fuel   | energy | carbon |
      | G      | 350.0  | 24.65  |
      | R      | 350.0  | 24.65  |
      | P      | 350.0  | 24.65  |
      | D      | 385.0  | 28.03  |
      | BP-B20 | 380.0  | 23.02  |
      | E      | 250.0  |  6.10  |
      | C      | 350.0  | 20.50  |
      | EL     | 350.0  | 61.87  |
      | H      | 350.0  |  1.0   |

  Scenario Outline: Calculations from make model year, distance, and automobile fuel
    Given it has "distance" of "100"
    And it has "make.name" of "<make>"
    And it has "model.name" of "<model>"
    And it has "year.year" of "<year>"
    And it has "automobile_fuel.code" of "<fuel>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make       | model     | year | fuel   | energy | carbon | notes |
      | Toyota     | Prius     | 2003 | R      | 199.21 | 14.06  | different code meaning gasoline |
      | Ford       | F150 FFV  | 2012 | E      | 440.48 |  9.65  | alt fuel |
      | Chevrolet  | Volt      | 2012 | EL     |  87.50 | 15.92  | alt fuel |
      | Volkswagen | Jetta     | 2003 | G      | 376.74 | 25.73  | |
      | Volkswagen | Jetta     | 2003 | BP-B20 | 246.30 | 14.98  | alt fuel |
      | Honda      | Civic CNG | 2003 | G      | 269.23 | 18.66  | not a fuel for this variant |
