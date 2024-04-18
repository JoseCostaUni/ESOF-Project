Feature: Notifications

  Scenario: User receives notification for event chat group activity
    Given the user is registered and logged into the app
    And the user has joined an event chat group
    When there is new activity (e.g., messages, updates) in the chat group
    Then the system should send a notification to the user
    And the user should be able to view the notification in their notification center

  Scenario: User receives notification for event detail updates
    Given the user is registered and logged into the app
    And the user has RSVP'd to an event
    When there are updates to the event details (e.g., time changes, location changes)
    Then the system should send a notification to the user
    And the user should be able to view the notification in their notification center

  Scenario: User turns off notifications for event chat groups
    Given the user is logged into the app
    And the user has previously enabled notifications for event chat groups
    When the user accesses their notification settings
    And disables notifications for event chat groups
    Then the system should stop sending notifications for event chat group activity to the user

  Scenario: User turns off notifications for event details
    Given the user is logged into the app
    And the user has previously enabled notifications for event details
    When the user accesses their notification settings
    And disables notifications for event details
    Then the system should stop sending notifications for event detail updates to the user
