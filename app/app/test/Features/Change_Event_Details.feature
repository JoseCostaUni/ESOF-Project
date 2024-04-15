Feature: Changing Event Details and Sending Notifications


Scenario: Modifying Event Details
Given I am logged in as an Event Administrator
When I navigate to the event details section
And I modify the event details
Then the changes should be saved successfully

Scenario: Sending Notifications to Participants
Given I am logged in as an Event Administrator
And the event details have been modified
When I choose to send notifications to participants
Then notifications should be sent to all participants

Scenario: Notification Content
Given I am logged in as an Event Administrator
And the event details have been modified
When I send notifications to participants
Then the notifications should include details of the changes