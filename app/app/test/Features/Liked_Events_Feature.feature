Feature: Liking events

Scenario: User likes an event
Given the user is logged in
And the user navigates to the "Main Page" page
When the user clicks on the "Heart" button for an event
Then the event should be added to the user's list of liked events
And the "Heart" button should change from black to red

Scenario: User unlikes an event
Given the user is logged in
And the user has liked an event
And the user navigates to the "Main Page" page
When the user clicks on the "Heart" button on an already liked event
Then the event should be removed from the user's list of liked events
And the "Heart" button should change from red to black

Scenario: Viewing liked events
Given the user is logged in
And the user has liked several events
When the user navigates to the "Liked Events" page
Then the user should see a list of all the events they have liked
