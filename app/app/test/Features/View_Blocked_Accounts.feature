Feature: Blocked Accounts

  As a registered user,
  I want the ability to view a list of accounts that I have blocked,
  So that I can review and manage my blocked contacts or accounts as needed.

  Scenario: User views their blocked accounts list
    Given the user is logged into the app
    And has previously blocked one or more accounts
    When the user accesses their account settings or privacy settings
    Then the system should display a list of accounts that the user has blocked
    And provide options to unblock or manage blocked accounts
