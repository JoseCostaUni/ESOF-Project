Feature: Share Profile

    As registered user,
    I want to be able to sideways scroll on the Search Page
    So that I can easily navigate back to the previous page

    Scenario: User returns to previous page with sideways scroll on Search Page
    Given the user has navigated to the Search Page from another page (e.g., Home page, Product page)
    When the user performs a sideways scroll on the Search Page
    Then the system should navigate the user back to the previous page