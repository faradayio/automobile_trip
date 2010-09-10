Feature: Automobile Trip Committee Calculations
  The automobile trip model should generate correct committee calculations

  Scenario: Fuel Use committee from default
    Given an automobile_trip emitter
    When the "fuel_use" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "57.0"

  Scenario: Emission factor committee from default
    Given an automobile_trip emitter
    When the "emission_factor" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "2.46315"

  Scenario: Emission committee from fuel use and emission factor
    Given an automobile_trip emitter
    And a characteristic "fuel_use" of "100"
    And a characteristic "emission_factor" of "1.5"
    When the "emission" committee is calculated
    Then the committee should have used quorum "from fuel use and emission factor"
    And the conclusion of the committee should be "150"
