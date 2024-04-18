Feature: Kick Participants from Event

As a event administrator
I want to be able to kick participants from my event
So that I can manage the list of participants and ensure that only desired users participate in the event

Scenario: User kicks a participant from the event successfully
Given the user is the organizer of the event
And there are participants enrolled in the event
When the user selects a participant to be kicked
And confirms the action
Then the participant should be removed from the event
And the participant should receive a notification about being kicked