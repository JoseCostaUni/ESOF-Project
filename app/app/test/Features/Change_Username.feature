Feature: Username Change

    Scenario: User changes their username
        Given the user is logged into the app
        When the user navigates to the account settings
        And selects the option to change their username
        Then the system should display a form to enter the new username
        And the user enters a new username
        And submits the form
        Then the system should validate the new username for uniqueness and length constraints
        And if the new username meets the criteria, update the user's username in the system
        And display a message confirming the username change

    Scenario: User cancels username change
        Given the user is on the username change form
        When the user decides to cancel the username change action
        Then the system should return the user to the account settings page
        And no changes should be made to the user's username

    Scenario: User attempts to change to an existing username
        Given the user is on the username change form
        When the user enters a new username that already exists in the system
        Then the system should display an error message indicating that the username is already taken
        And prompt the user to enter a different username

    Scenario: User attempts to change to an invalid username
        Given the user is on the username change form
        When the user enters a new username that does not meet the system's criteria (e.g., contains invalid characters, exceeds length limits)
        Then the system should display an error message indicating that the username is invalid
        And prompt the user to enter a valid username