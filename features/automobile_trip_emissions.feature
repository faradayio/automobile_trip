Feature: Automobile Trip Emissions Calculations
  The automobile trip model should generate correct emission calculations

  Scenario: Calculations from nothing
    Given an automobile_trip has nothing
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "4.74"

  Scenario Outline: Calculations from date
    Given an automobile_trip has "date" of "<date>"
    And it is the year "2010"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | date       | emission |
      | 2009-06-25 | 0.0      |
      | 2010-06-25 | 4.74     |
      | 2011-06-25 | 0.0      |

  Scenario Outline: Calculations from date and timeframe
    Given an automobile_trip has "date" of "<date>"
    And it has "timeframe" of "<timeframe>"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | date       | timeframe             | emission |
      | 2009-06-25 | 2009-01-01/2009-01-31 | 0.0      |
      | 2009-06-25 | 2009-01-01/2009-12-31 | 4.74     |
      | 2009-06-25 | 2009-12-01/2009-12-31 | 0.0      |

  Scenario: Calculations from urbanity
    Given an automobile_trip has "urbanity" of "0.5"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "4.74"

  Scenario Outline: Calculations from hybridity and urbanity
    Given an automobile_trip has "hybridity" of "<hybridity>"
    And it has "urbanity" of "0.5"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 3.39     |
      | false     | 4.78     |

  Scenario: Calculations from make and urbanity
    Given an automobile_trip has "urbanity" of "0.5"
    And it has "make.name" of "Toyota"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "4.07"

  Scenario Outline: Calculations from make, hybridity and urbanity
    Given an automobile_trip has "hybridity" of "<hybridity>"
    And it has "urbanity" of "0.5"
    And it has "make.name" of "Toyota"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 2.91     |
      | false     | 4.10     |

  Scenario: Calculations from make year and urbanity
    Given an automobile_trip has "urbanity" of "0.5"
    And it has "make_year.name" of "Toyota 2003"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "2.71"

  Scenario Outline: Calculations from make year, hybridity and urbanity
    Given an automobile_trip has "hybridity" of "<hybridity>"
    And it has "urbanity" of "0.5"
    And it has "make_year.name" of "Toyota 2003"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 1.94     |
      | false     | 2.74     |

  Scenario: Calculations from size class and urbanity
    Given an automobile_trip has "urbanity" of "0.5"
    And it has "size_class.name" of "Midsize Car"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "3.05"

  Scenario Outline: Calculations from size class, hybridity, and urbanity
    Given an automobile_trip has "hybridity" of "<hybridity>"
    And it has "urbanity" of "0.5"
    And it has "size_class.name" of "Midsize Car"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 1.78     |
      | false     | 3.56     |

  Scenario: Calculations from make model and urbanity
    Given an automobile_trip has "urbanity" of "0.5"
    And it has "make_model.name" of "Toyota Prius"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "1.69"

  Scenario: Calculations from make model year and urbanity
    Given an automobile_trip has "urbanity" of "0.5"
    And it has "make_model_year.name" of "Toyota Prius 2003"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "1.19"

  Scenario: Calculations from make model year variant and urbanity
    Given an automobile_trip has "urbanity" of "0.5"
    And it has "make_model_year_variant.row_hash" of "xxx1"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "0.92"

  Scenario: Calculations from speed and duration
    Given an automobile_trip has "speed" of "5.0"
    And it has "duration" of "120.0"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "2.90"

  Scenario: Calculations from driveable locations
    Given an automobile_trip has "origin" of "43,-73"
    And the geocoder will encode the origin as "43,-73"
    And it has "destination" of "43.1,-73"
    And the geocoder will encode the destination as "43.1,-73"
    And mapquest will return a distance of "57.91" kilometres
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "16.81"

  Scenario: Calculations from non-driveable locations
    Given an automobile_trip has "origin" of "Lansing, MI"
    And the geocoder will encode the origin as "42.732535,-84.5555347"
    And it has "destination" of "Canterbury, Kent, UK"
    And the geocoder will encode the destination as "51.2772689,1.0805173"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "4.74"

  Scenario: Calculations from fuel efficiency and distance
    Given an automobile_trip has "fuel_efficiency" of "10.0"
    And it has "distance" of "100.0"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "24.9"

  Scenario: Calculations from fuel use and fuel type
    Given an automobile_trip has "fuel_use" of "20.0"
    And it has "fuel_type.name" of "regular gasoline"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "50.0"
