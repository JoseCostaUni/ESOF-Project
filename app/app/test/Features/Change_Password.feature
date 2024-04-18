Feature: Password Change


    Scenario: User changes their password
        Given the user is logged into the app
        When the user navigates to the account settings
        And selects the option to change their password
        Then the system should prompt the user to enter their current password
        And the user enters their current password
        And the system verifies the correctness of the current password
        Then the system should display a form to enter the new password
        And the user enters a new password
        And submits the form
        Then the system should update the user's password in the system
        And display a message confirming the password change

    Scenario: User cancels password change
        Given the user is on the password change form
        When the user decides to cancel the password change action
        Then the system should return the user to the account settings page
        And no changes should be made to the user's password

    Scenario: User enters incorrect current password
        Given the user is on the password change form
        When the user enters an incorrect current password
        Then the system should display an error message indicating that the current password is incorrect
        And prompt the user to enter the correct current password

    Scenario: User attempts to set a weak password
        Given the user is on the password change form
        When the user enters a new password that does not meet the system's password strength requirements
        Then the system should display an error message indicating that the password is too weak
        And prompt the user to enter a stronger password