Feature: Event Group Chat Creation

  Background:
    Given I am logged in as an Event Administrator

  Scenario: Creating Group Chat for Event
    When I navigate to the event management dashboard
    And I select the option to create a group chat
    Then a new group chat should be created for the event
    And all attendees should be added to the group chat automatically

  Scenario: Group Chat Functionality
    Given a group chat has been created for the event
    When I access the group chat
    Then I should be able to send messages to all attendees
    And attendees should be able to communicate with each other within the group chat
