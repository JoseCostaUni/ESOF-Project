Feature: Sign In

    Scenario: User successfully signs in with valid credentials
        Given the user is on the sign-in page
        When the user enters valid credentials (email and password)
        And submits the sign-in form
        Then the system should authenticate the user
        And redirect the user to the home page
        And display a welcome message

    Scenario: User tries to sign in with invalid email
        Given the user is on the sign-in page
        When the user enters an invalid email format
        And submits the sign-in form
        Then the system should display an error message indicating that the email format is invalid

    Scenario: User tries to sign in with incorrect password
        Given the user is on the sign-in page
        When the user enters a valid email and an incorrect password
        And submits the sign-in form
        Then the system should display an error message indicating that the password is incorrect

    Scenario: User tries to sign in with non-existing email
        Given the user is on the sign-in page
        And there is no account associated with the entered email
        When the user enters a non-existing email
        And submits the sign-in form
        Then the system should display an error message indicating that the email is not registered