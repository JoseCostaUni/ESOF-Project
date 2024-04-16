Feature: About Page

  As a user,
  I want to be able to access and view the "About" page of the application,
  So that I can learn more about the purpose, mission, and team behind the app.

  Scenario: User navigates to the About page
    Given the user is logged into the app
    When the user accesses the About page from the app menu or navigation
    Then the system should display information about the app's purpose, mission, and team
    And provide links or references for further information, such as a website or contact details
