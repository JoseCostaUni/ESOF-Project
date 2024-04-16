Feature: Account Deletion


    Scenario: User deletes their account
        Given the user is logged into the app
        When the user navigates to the account settings
        And selects the option to delete their account
        Then the system should prompt the user for confirmation
        And upon confirmation, the system should permanently delete the user's account
        And log the user out of the app
        And display a message confirming the account deletion

    Scenario: User cancels account deletion
        Given the user is on the account deletion confirmation prompt
        When the user cancels the account deletion action
        Then the system should return the user to the account settings page
        And no changes should be made to the user's account

    Scenario: User attempts to log in after account deletion
        Given the user has successfully deleted their account
        When the user attempts to log in again
        Then the system should display an error message indicating that the account does not exist
        And prevent the user from accessing any features requiring authentication