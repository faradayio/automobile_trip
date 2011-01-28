Feature: Automobile Trip Committee Calculations
  The automobile trip model should generate correct committee calculations

  Scenario: Date committee from timeframe
    Given an automobile_trip emitter
    And a characteristic "timeframe" of "2009-06-06/2010-01-01"
    When the "date" committee is calculated
    Then the committee should have used quorum "from timeframe"
    And the conclusion of the committee should be "2009-06-06"

  Scenario: Urbanity committee from default
    Given an automobile_trip emitter
    When the "urbanity" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "0.43"

  Scenario: Hybridity multiplier committee from default
    Given an automobile_trip emitter
    When the "hybridity_multiplier" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "1.0"

  Scenario Outline: Hybridity multiplier committee from hybridity and urbanity
    Given an automobile_trip emitter
    And a characteristic "hybridity" of "<hybridity>"
    When the "urbanity" committee is calculated
    And the "hybridity_multiplier" committee is calculated
    Then the committee should have used quorum "from hybridity and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | multiplier |
      | true      | 1.36919    |
      | false     | 0.99211    |

  Scenario Outline: Hybridity multiplier committee from size class missing hybridity multipliers
    Given an automobile_trip emitter
    And a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "urbanity" committee is calculated
    And the "hybridity_multiplier" committee is calculated
    Then the committee should have used quorum "from hybridity and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | size_class    | multiplier |
      | true      | Midsize Wagon | 1.36919    |
      | false     | Midsize Wagon | 0.99211    |

  Scenario Outline: Hybridity multiplier committee from size class with hybridity multipliers
    Given an automobile_trip emitter
    And a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "urbanity" committee is calculated
    And the "hybridity_multiplier" committee is calculated
    Then the committee should have used quorum "from size class, hybridity, and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | size_class  | multiplier |
      | true      | Midsize Car | 1.68067    |
      | false     | Midsize Car | 0.87464    |

  Scenario Outline: Fuel efficiency committee from hybridity multiplier
    Given an automobile_trip emitter
    And a characteristic "hybridity_multiplier" of "<multiplier>"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from hybridity multiplier"
    And the conclusion of the committee should be "<fe>"
    Examples:
      | multiplier | fe       |
      | 1.0        |  8.58025 |
      | 1.5        | 12.87038 |

  Scenario: Fuel efficiency committee from make and hybridity multiplier
    Given an automobile_trip emitter
    And a characteristic "make.name" of "Toyota"
    And a characteristic "hybridity_multiplier" of "2.0"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make and hybridity multiplier"
    And the conclusion of the committee should be "20.0"

  Scenario: Fuel efficiency committee from make year and hybridity multiplier
    Given an automobile_trip emitter
    And a characteristic "make_year.name" of "Toyota 2003"
    And a characteristic "hybridity_multiplier" of "2.0"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make year and hybridity multiplier"
    And the conclusion of the committee should be "30.0"

  Scenario: Fuel efficiency committee from size class, hybridity multiplier, and urbanity
    Given an automobile_trip emitter
    And a characteristic "size_class.name" of "Midsize Car"
    And a characteristic "hybridity_multiplier" of "2.0"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from size class, hybridity multiplier, and urbanity"
    And the conclusion of the committee should be "26.66667"

  Scenario: Fuel efficiency committee from make model and urbanity
    Given an automobile_trip emitter
    And a characteristic "make_model.name" of "Toyota Prius"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make model and urbanity"
    And the conclusion of the committee should be "24.0"

  Scenario: Fuel efficiency committee from make model year and urbanity
    Given an automobile_trip emitter
    And a characteristic "make_model_year.name" of "Toyota Prius 2003"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make model year and urbanity"
    And the conclusion of the committee should be "34.28571"

  Scenario: Fuel efficiency committee from make model year variant and urbanity
    Given an automobile_trip emitter
    And a characteristic "make_model_year_variant.row_hash" of "xxx1"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make model year variant and urbanity"
    And the conclusion of the committee should be "44.44444"

  Scenario: Speed committee from urbanity
    Given an automobile_trip emitter
    When the "urbanity" committee is calculated
    And the "speed" committee is calculated
    Then the committee should have used quorum "from urbanity"
    And the conclusion of the committee should be "50.94388"

  Scenario Outline: Origin location from geocodeable origin
    Given a automobile_trip emitter
    And a characteristic "origin" of address value "<origin>"
    And the geocoder will encode the origin as "<geocode>"
    When the "origin_location" committee is calculated
    Then the committee should have used quorum "from origin"
    And the conclusion of the committee should be "<location>"
    Examples:
      | origin                               | geocode                 | location                |
      | 05753                                | 43.9968185,-73.1491165  | 43.9968185,-73.1491165  |
      | San Francisco, CA                    | 37.7749295,-122.4194155 | 37.7749295,-122.4194155 |
      | 488 Haight Street, San Francisco, CA | 37.7722302,-122.4303328 | 37.7722302,-122.4303328 |
      | Canterbury, Kent, UK                 | 51.2772689,1.0805173    | 51.2772689,1.0805173    |

  Scenario: Origin location from non-geocodeable origin
    Given a automobile_trip emitter
    And a characteristic "origin" of "Bag End, Hobbiton, Westfarthing, The Shire, Eriador, Middle Earth"
    And the geocoder will encode the origin as ","
    When the "origin_location" committee is calculated
    Then the conclusion of the committee should be nil

  Scenario Outline: Destination location from geocodeable destination
    Given a automobile_trip emitter
    And a characteristic "destination" of address value "<destination>"
    And the geocoder will encode the destination as "<geocode>"
    When the "destination_location" committee is calculated
    Then the committee should have used quorum "from destination"
    And the conclusion of the committee should be "<location>"
    Examples:
      | destination                          | geocode                 | location                |
      | 05753                                | 43.9968185,-73.1491165  | 43.9968185,-73.1491165  |
      | San Francisco, CA                    | 37.7749295,-122.4194155 | 37.7749295,-122.4194155 |
      | 488 Haight Street, San Francisco, CA | 37.7722302,-122.4303328 | 37.7722302,-122.4303328 |
      | Canterbury, Kent, UK                 | 51.2772689,1.0805173    | 51.2772689,1.0805173    |

  Scenario: Destination location from non-geocodeable destination
    Given a automobile_trip emitter
    And a characteristic "destination" of "Bag End, Hobbiton, Westfarthing, The Shire, Eriador, Middle Earth"
    And the geocoder will encode the destination as ","
    When the "destination_location" committee is calculated
    Then the conclusion of the committee should be nil

  Scenario: Distance committee from default
    Given an automobile_trip emitter
    When the "distance" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "16.33484"

  Scenario: Distance committee from duration and speed
    Given an automobile_trip emitter
    And a characteristic "duration" of "120.0"
    And a characteristic "speed" of "5.0"
    When the "distance" committee is calculated
    Then the committee should have used quorum "from duration and speed"
    And the conclusion of the committee should be "10.0"

  Scenario Outline: Distance committee from origin and destination locations
    Given an automobile_trip emitter
    And a characteristic "origin_location" of "<origin>"
    And a characteristic "destination_location" of "<destination>"
    And a characteristic "mapquest_api_key" of "ABC123"
    And mapquest determines the distance to be "<mapquest_distance>"
    When the "distance" committee is calculated
    Then the committee should have used quorum "from origin and destination locations"
    And the conclusion of the committee should be "<distance>"
    Examples:
      | origin | destination | mapquest_distance | distance |
      | 43,-73 | 43,-73      | 0.0               | 0.0      |
      | 43,-73 | 43.1,-73    | 57.93638          | 57.93638 |

  Scenario: Distance commitee from undriveable origin and destination locations
    Given an automobile_trip emitter
    And a characteristic "origin" of "Lansing, MI"
    And a characteristic "destination" of "Canterbury, Kent, UK"
    And a characteristic "mapquest_api_key" of "ABC123"
    When the "origin_location" committee is calculated
    And the "destination_location" committee is calculated
    And the "distance" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "16.33484"

  Scenario: Fuel use committee from fuel efficiency and distance
    Given an automobile_trip emitter
    And a characteristic "fuel_efficiency" of "10.0"
    And a characteristic "distance" of "100.0"
    When the "fuel_use" committee is calculated
    Then the committee should have used quorum "from fuel efficiency and distance"
    And the conclusion of the committee should be "10.0"

  Scenario: Fuel type committee from make model year variant
    Given an automobile_trip emitter
    And a characteristic "make_model_year_variant.row_hash" of "xxx1"
    When the "fuel_type" committee is calculated
    Then the committee should have used quorum "from make model year variant"
    And the conclusion of the committee should have "name" of "regular gasoline"

  Scenario: Emission factor committee from default
    Given an automobile_trip emitter
    When the "emission_factor" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "2.49011"

  Scenario: Emission factor committee from fuel type
    Given an automobile_trip emitter
    And a characteristic "fuel_type.name" of "regular gasoline"
    And the "emission_factor" committee is calculated
    Then the committee should have used quorum "from fuel type"
    And the conclusion of the committee should be "2.5"
