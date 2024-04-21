Feature: Cancelling the Event and Sending Notifications

Scenario: Cancelling the Event
Given I am logged in as an Event Administrator
When I decide to cancel the event
Then the event status should be changed to "Cancelled"

Scenario: Notification Content
Given I am logged in as an Event Administrator
And the event has been cancelled
When I send notifications to participants about the cancellation
Then the notifications should clearly state that the event has been cancelled