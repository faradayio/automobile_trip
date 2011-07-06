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

  Scenario: Calculations from urbanity estimate
    Given an automobile_trip has "urbanity_estimate" of "0.5"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "4.72"

  Scenario Outline: Calculations from hybridity and urbanity estimate
    Given an automobile_trip has "hybridity" of "<hybridity>"
    And it has "urbanity_estimate" of "0.5"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 3.37     |
      | false     | 4.76     |

  Scenario: Calculations from make and urbanity estimate
    Given an automobile_trip has "urbanity_estimate" of "0.5"
    And it has "make.name" of "Toyota"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "3.88"

  Scenario Outline: Calculations from make, hybridity and urbanity estimate
    Given an automobile_trip has "hybridity" of "<hybridity>"
    And it has "urbanity_estimate" of "0.5"
    And it has "make.name" of "Toyota"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 2.77     |
      | false     | 3.91     |

  Scenario: Calculations from make year and urbanity estimate
    Given an automobile_trip has "urbanity_estimate" of "0.5"
    And it has "make_year.name" of "Toyota 2003"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "2.59"

  Scenario Outline: Calculations from make year, hybridity and urbanity estimate
    Given an automobile_trip has "hybridity" of "<hybridity>"
    And it has "urbanity_estimate" of "0.5"
    And it has "make_year.name" of "Toyota 2003"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 1.85     |
      | false     | 2.61     |

  Scenario: Calculations from size class and urbanity estimate
    Given an automobile_trip has "urbanity_estimate" of "0.5"
    And it has "size_class.name" of "Midsize Car"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "2.91"

  Scenario Outline: Calculations from size class, hybridity, and urbanity estimate
    Given an automobile_trip has "hybridity" of "<hybridity>"
    And it has "urbanity_estimate" of "0.5"
    And it has "size_class.name" of "Midsize Car"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 1.70     |
      | false     | 3.40     |

  Scenario: Calculations from make model and urbanity estimate
    Given an automobile_trip has "urbanity_estimate" of "0.5"
    And it has "make_model.name" of "Toyota Prius"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "1.62"

  Scenario: Calculations from make model year and urbanity estimate
    Given an automobile_trip has "urbanity_estimate" of "0.5"
    And it has "make_model_year.name" of "Toyota Prius 2003"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "1.13"

  Scenario: Calculations from make model year variant and urbanity estimate
    Given an automobile_trip has "urbanity_estimate" of "0.5"
    And it has "make_model_year_variant.row_hash" of "xxx1"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "1.02"

  Scenario: Calculations from speed and duration
    Given an automobile_trip has "speed" of "5.0"
    And it has "duration" of "7200.0"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "2.95"

  Scenario: Calculations from driveable locations
    Given an automobile_trip has "origin" of "43,-73"
    And the geocoder will encode the origin as "43,-73"
    And it has "destination" of "43.1,-73"
    And the geocoder will encode the destination as "43.1,-73"
    And mapquest will return a distance of "57.93638" kilometres
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "17.08"

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
