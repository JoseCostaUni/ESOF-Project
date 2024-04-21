Feature: Event Search


    Scenario: User searches events with filters
        Given the user is on the search page
        When the user applies filters such as date, location, category, and price
        Then the system should display events that match the applied filters

    Scenario: User searches events with no filters
        Given the user is on the search page
        When the user does not apply any filters
        Then the system should display all available events

    Scenario: User applies date filter
        Given the user is on the search page
        When the user applies a date filter
        Then the system should only display events that occur on the specified date

    Scenario: User applies location filter
        Given the user is on the search page
        When the user applies a location filter
        Then the system should only display events that are located in the specified area

    Scenario: User applies category filter
        Given the user is on the search page
        When the user applies a category filter
        Then the system should only display events that belong to the specified category

    Scenario: User applies price filter
        Given the user is on the search page
        When the user applies a price filter
        Then the system should only display events that fall within the specified price range