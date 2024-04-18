Feature: View Main Page


    Scenario: User views the main page
        Given the user accesses the application
        When the user navigates to the main page
        Then the user should see a list of events
        And the user should be able to choose which events to attend