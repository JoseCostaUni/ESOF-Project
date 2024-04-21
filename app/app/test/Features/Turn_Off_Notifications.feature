Feature: Turn Off Notifications

  As a registered user,
  I want the ability to turn off notifications for event chat groups and event details,
  So that I can manage my notification preferences and avoid receiving unnecessary alerts.

  Scenario: User turns off notifications for event chat groups
    Given the user is logged into the app
    And the user has previously enabled notifications for event chat groups
    When the user accesses their notification settings
    And selects the option to turn off notifications for event chat groups
    Then the system should stop sending notifications for event chat group activity to the user
    And confirm that notifications for event chat groups have been successfully turned off

  Scenario: User turns off notifications for event details
    Given the user is logged into the app
    And the user has previously enabled notifications for event details
    When the user accesses their notification settings
    And selects the option to turn off notifications for event details
    Then the system should stop sending notifications for event detail updates to the user
    And confirm that notifications for event details have been successfully turned off

  Scenario: User attempts to turn off notifications that are already off
    Given the user is logged into the app
    And the user has already turned off notifications for event chat groups
    When the user accesses their notification settings
    And attempts to turn off notifications for event chat groups again
    Then the system should display a message indicating that notifications for event chat groups are already turned off
    And provide options to manage other notification settings

  Scenario: User attempts to turn off notifications without being logged in
    Given the user is not logged into the app
    When the user attempts to access notification settings to turn off notifications
    Then the system should prompt the user to log in
    And once logged in, allow the user to manage notification settings as usual
