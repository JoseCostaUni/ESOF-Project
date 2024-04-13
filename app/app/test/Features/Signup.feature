Feature: User Sign Up
  Tests the sign-up functionality of the application

  Background: Set up sign-up form
    Given I am on the sign-up page

  Scenario: Fill and submit sign-up form
    Given the user enters their name "John"
    And the user enters their surname "Doe"
    And the user enters their email "john.doe@example.com"
    And the user enters their password "password123"
    When the user submits the sign-up form
    Then the user should be redirected to their profile page

  @debug
  Scenario: Sign up with an existing email
    Given the user enters an existing email "existing.user@example.com"
    And the user enters their name "Jane"
    And the user enters their surname "Doe"
    And the user enters their password "password456"
    When the user submits the sign-up form
    Then an error message should be displayed

  Scenario: Sign up with missing information
    Given the user does not enter their name
    And the user enters their surname "Doe"
    And the user enters their email "john.doe@example.com"
    And the user enters their password "password789"
    When the user submits the sign-up form
    Then an error message should be displayed

  Examples: Validation of characters in name field
    | characters | result |
    | abc        | 294    |
    | a b c      | 358    |
    | a \n b \c  | 684    |