Feature: Event Search


    Scenario: User searches events with filters
        Given the user is on the search page
        When the user applies filters 
        Then the system should display events that match the applied filters

    Scenario: User searches events with no filters
        Given the user is on the search page
        When the user does not apply any filters
        Then the system should display all available events

    Scenario: User searches events with invalid filters
        Given the user is on the search page
        When the user applies invalid filters
        Then the system should display an error message