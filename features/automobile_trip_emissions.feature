Feature: Automobile Trip Emissions Calculations
  The automobile trip model should generate correct emission calculations

  Scenario: Calculations starting from nothing
    Given an automobile_trip has nothing
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "140.4"

  Scenario: Calculations starting from fuel use
    Given an automobile_trip has "fuel_use" of "100"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "246.3"

  Scenario: Calculations starting from fuel type
    Given an automobile_trip has "fuel_type.name" of "Gasoline"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "570.0"

  Scenario: Calculations starting from fuel use and fuel type
    Given an automobile_trip has "fuel_type.name" of "Gasoline"
    And it has "fuel_use" of "100"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "1000.0"
