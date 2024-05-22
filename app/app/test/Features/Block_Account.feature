Feature: Block Account

Scenario: User blocks an account successfully
Given the user is logged in
When the user navigates to the profile of the account they want to block
And selects the option to block the account
Then the account should be successfully blocked
And the user should not see any activity from the blocked account

Scenario: User unblocks a previously blocked account
Given the user is logged in
And has previously blocked an account
When the user navigates to the blocked accounts page
And selects the option to unblock the account
Then the account should be successfully unblocked
And the user should start seeing activity from the unblocked account