Feature: Create Events

Scenario: User creates an event successfully
Given the user is logged in
When the user navigates to the create event page
And fills in the required event details (title, date, location, description, etc.)
And submits the event creation form
Then the event should be created successfully
And the user should be redirected to the event page
And the event details should be displayed correctly

Scenario: User attempts to create an event with missing required information
Given the user is logged in
When the user navigates to the create event page
And leaves one or more required fields empty
And submits the event creation form
Then an error message should be displayed indicating the missing information
And the event should not be created

Scenario: User cancels event creation
Given the user is logged in
When the user navigates to the create event page
And decides to cancel event creation
Then the user should be redirected back to the previous page
And no event should be created

Scenario: User creates an event with a past date
Given the user is logged in
When the user navigates to the create event page
And sets the event date in the past
And submits the event creation form
Then an error message should be displayed indicating that the event date must be in the future
And the event should not be created

Scenario: User attempts to create an event with an existing title
Given the user is logged in
And there exists an event with the same title
When the user navigates to the create event page
And fills in the event details with the existing event's title
And submits the event creation form
Then an error message should be displayed indicating that an event with the same title already exists
And the event should not be created