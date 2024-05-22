 Feature:  See Other User Accounts
        Scenario: User views other user accounts
        Given the user is on the Search Page
        Given the user has searched for a user account
        When the user clicks on a user account
        Then the user should see the user account details
        And the user should see the user account's posts