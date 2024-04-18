Feature: Logout

    Scenario: User logs out from the account
        Given the user is logged in to their account
        When the user clicks on the logout button
        Then the system should log the user out and redirect them to the login page

    Scenario: User tries to access restricted pages after logout
        Given the user was logged in but has logged out
        When the user tries to access restricted pages
        Then the system should redirect the user to the login page

    Scenario: User session expires
        Given the user is logged in
        When the user's session expires due to inactivity
        Then the system should automatically log the user out and redirect them to the login page