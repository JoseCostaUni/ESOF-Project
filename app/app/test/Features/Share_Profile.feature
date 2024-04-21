Feature: Share Profile

  As a registered user,
  I want to be able to share my profile with others,
  Either within the app or through external platforms,
  So that I can easily connect with friends or share my profile for networking purposes.

  Scenario: User shares their profile within the app
    Given the user is logged into the app
    When the user navigates to their profile page
    And selects the option to share their profile
    Then the system should provide options to share the profile via messaging or social media platforms integrated into the app
    And generate a shareable link or code for the user's profile

  Scenario: User shares their profile through external platforms
    Given the user is logged into the app
    When the user accesses their profile settings
    And selects the option to share their profile
    Then the system should provide options to share the profile via external platforms (e.g., Facebook, Twitter, LinkedIn)
    And generate a shareable link or code for the user's profile
