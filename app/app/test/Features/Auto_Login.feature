Feature: Auto Log In

Scenario: User enables auto-login option
Given the user is logged in
And the auto-login option is available in the settings
When the user enables the auto-login option
Then the system should remember the user's credentials securely

Scenario: User starts the app after enabling auto-login
Given the user has previously enabled the auto-login option
And the app is restarted
When the app starts
Then the system should automatically log in the user using the stored credentials
And redirect the user to the home page
And display a welcome message

Scenario: User disables auto-login option
Given the user has previously enabled the auto-login option
And the auto-login option is available in the settings
When the user disables the auto-login option
Then the system should forget the stored credentials