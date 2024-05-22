Feature: Redirect Search Events to the specific page

    As a user, I want to be able to search for events and be redirected to the specific page of the event I am looking for , so that 
    I am able to check the event's information.

    Scenario: Redirect Search Events to the specific page
        Given I am on the search page
        When I search for an event
        When I click on the event
        Then I should be redirected to the specific page of the event I am looking for