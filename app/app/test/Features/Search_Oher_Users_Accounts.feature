Feature: Event Search

    Scenario: User searches users  
        Given the user is on the search page
        When the user searches for a user
        Then the system should display users that match the search query
