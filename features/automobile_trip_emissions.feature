Feature: Automobile Trip Emissions Calculations
  The automobile trip model should generate correct emission calculations

  Scenario: Calculations from nothing
    Given an automobile_trip has nothing
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "4.72"

  Scenario Outline: Calculations from date
    Given an automobile_trip has "date" of "<date>"
    And it is the year "2010"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | date       | emission |
      | 2009-06-25 | 0.0      |
      | 2010-06-25 | 4.72     |
      | 2011-06-25 | 0.0      |

  Scenario Outline: Calculations from date and timeframe
    Given an automobile_trip has "date" of "<date>"
    And it has "timeframe" of "<timeframe>"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | date       | timeframe             | emission |
      | 2009-06-25 | 2009-01-01/2009-01-31 | 0.0      |
      | 2009-06-25 | 2009-01-01/2009-12-31 | 4.72     |
      | 2009-06-25 | 2009-12-01/2009-12-31 | 0.0      |

  Scenario: Calculations from country
    Given an automobile_trip has "country.iso_3166_code" of "US"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "4.31"

  Scenario: Calculations from urbanity
    Given an automobile_trip has "urbanity" of "0.5"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "4.72"

  Scenario Outline: Calculations from hybridity and urbanity
    Given an automobile_trip has "hybridity" of "<hybridity>"
    And it has "urbanity" of "0.5"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 3.37     |
      | false     | 4.71     |

  Scenario: Calculations from make and urbanity
    Given an automobile_trip has "urbanity" of "0.5"
    And it has "make.name" of "Toyota"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "3.88"

  Scenario Outline: Calculations from make, hybridity and urbanity
    Given an automobile_trip has "hybridity" of "<hybridity>"
    And it has "urbanity" of "0.5"
    And it has "make.name" of "Toyota"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 2.77     |
      | false     | 3.88     |

  Scenario: Calculations from make year and urbanity
    Given an automobile_trip has "urbanity" of "0.5"
    And it has "make_year.name" of "Toyota 2003"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "2.59"

  Scenario Outline: Calculations from make year, hybridity and urbanity
    Given an automobile_trip has "hybridity" of "<hybridity>"
    And it has "urbanity" of "0.5"
    And it has "make_year.name" of "Toyota 2003"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 1.85     |
      | false     | 2.58     |

  Scenario: Calculations from size class and urbanity
    Given an automobile_trip has "urbanity" of "0.5"
    And it has "size_class.name" of "Midsize Car"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "2.91"

  Scenario Outline: Calculations from size class, hybridity, and urbanity
    Given an automobile_trip has "hybridity" of "<hybridity>"
    And it has "urbanity" of "0.5"
    And it has "size_class.name" of "Midsize Car"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 1.70     |
      | false     | 2.91     |

  Scenario: Calculations from make model and urbanity
    Given an automobile_trip has "urbanity" of "0.5"
    And it has "make_model.name" of "Toyota Prius"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "1.62"

  Scenario: Calculations from make model year and urbanity
    Given an automobile_trip has "urbanity" of "0.5"
    And it has "make_model_year.name" of "Toyota Prius 2003"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "1.13"

  Scenario: Calculations from make model year variant and urbanity
    Given an automobile_trip has "urbanity" of "0.5"
    And it has "make_model_year_variant.row_hash" of "xxx1"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "1.02"

  Scenario: Calculations from speed and duration
    Given an automobile_trip has "speed" of "5.0"
    And it has "duration" of "7200.0"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "2.95"

  Scenario: Calculations from driveable locations
    Given an automobile_trip has "origin" of "44,-73.15"
    And the geocoder will encode the origin as "44,-73.15"
    And it has "destination" of "44.1,-73.15"
    And the geocoder will encode the destination as "44.1,-73.15"
    And mapquest determines the distance in miles to be "8.142"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "3.86"

  Scenario: Calculations from non-driveable locations
    Given an automobile_trip has "origin" of "Lansing, MI"
    And the geocoder will encode the origin as "42.732535,-84.5555347"
    And it has "destination" of "Canterbury, Kent, UK"
    And the geocoder will encode the destination as "51.2772689,1.0805173"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "4.72"

  Scenario: Calculations from fuel efficiency and distance
    Given an automobile_trip has "fuel_efficiency" of "10.0"
    And it has "distance" of "100.0"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "24.25"

  Scenario Outline: Calculations from fuel use and fuel
    Given an automobile_trip has "fuel_use" of "20.0"
    And it has "automobile_fuel.name" of "<fuel>"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | fuel             | emission |
      | regular gasoline | 48.20    |
      | diesel           | 56.44    |
      | B20              | 46.44    |
