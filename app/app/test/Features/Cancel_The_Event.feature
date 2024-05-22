Feature: Canceling an event

Scenario: User cancels an event
Given the user is logged in
And the user navigates to the "Profile" page
And the user enter the "Created Events" tab
And the user has an event they want to cancel
When the user clicks on the "Edit Event" button for that event
Then the user clicks on the "Delete Event" button
Then the event should be deleted
And the event should no longer appear in the list of upcoming events

Scenario: User decides not to cancel an event
Given the user is logged in
And the user navigates to the "Profile" page
And the user enter the "Created Events" tab
And the user has an event they are considering to cancel
When the user clicks on the "Edit Event" button for that event
Then the user doesn't want to cancel the event anymore and doesn't click on the "Delete Event" button
Then the event shouldn't be deleted
And the event should still appear in the list of upcoming events
