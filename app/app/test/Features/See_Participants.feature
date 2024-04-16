Feature: Viewing Participants in an Event

Scenario: Displaying Participant List
Given I am logged in as an Event Administrator
When I navigate to the participant section of the event
Then I should see a list of participants

Scenario: Real-Time Updates
Given I am logged in as an Event Administrator
When participants are added or removed from the event
Then the participant list should update in real-time

Scenario: Accessing Participant Details
Given I am logged in as an Event Administrator
When I view the participant list
Then I should be able to access details of each participant

Scenario: User-Friendly Interface
Given I am logged in as an Event Administrator
When I navigate to the participant section of the event
Then the interface should be intuitive and easy to use

