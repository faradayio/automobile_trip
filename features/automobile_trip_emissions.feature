Feature: Automobile Trip Emissions Calculations
  The automobile trip model should generate correct emission calculations

  Scenario: Standard Calculations for automobiles
    Given an automobile
    When emissions are calculated
    Then the emission value should be 1
