Feature: Adding Event to Map
    As a user
    I want to be able to add an event to the map
    So that others can see and join the event

    Scenario: Add event to the map
        Given I am on the Create event page
        When i click on textfield on Create event page
        Then I should see a form to enter the location of the event
        When I click on the "Create Event" button  
        Then the event should be added to the map
        And the event marker should be visible on the map