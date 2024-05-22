Feature: Change Type Of Events In Profile

    As a user, I would like to be able to change the type of events that I am seeing in my profile so that I can see the events that I am interested in.

    Scenario: Change Type Of Events In Profile
    Given I am on the profile page
    When I click on the "Created Events" button
    Then I should see a list of event types that I can created


    Given I am on the profile page
    When I click on the "Past Events" button
    Then I should see a list of event that have happened passed and that I created or joind 

    Given I am on the profile page
    When I click on the "joind Events" button
    Then I should see a list of event that have not alredy happened and that I joind 