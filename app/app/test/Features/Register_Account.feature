Feature: Register Account


    Scenario: User successfully registers a new account
        Given the user is on the registration page
        When the user fills in the required registration details
        And submits the registration form
        Then the system should create a new account for the user
        And redirect the user to the login page
        And display a success message confirming the registration

    Scenario: User tries to register with existing email address
        Given the user is on the registration page
        And there is an existing account with the same email address
        When the user fills in the registration form with the existing email address
        And submits the registration form
        Then the system should display an error message indicating that the email address is already in use

    Scenario: User tries to register with weak password
        Given the user is on the registration page
        When the user fills in the registration form with a weak password
        And submits the registration form
        Then the system should display an error message indicating that the password is too weak

    Scenario: User tries to register with invalid email format
        Given the user is on the registration page
        When the user fills in the registration form with an invalid email format
        And submits the registration form
        Then the system should display an error message indicating that the email format is invalid

