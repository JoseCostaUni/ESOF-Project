Feature: Add multiple photos to an event

Scenario: User adds multiple photos to an event
Given the user is logged in
And the user navigates to the "Create Event" page
When the user fills in the event details with "Event Title" and "Event Description"
And the user clicks on the "Add Photos" button
And the user selects multiple photos from their device
And the user clicks on the "Upload" button
Then the selected photos should be displayed as thumbnails on the event creation page
When the user clicks the "Save" button to create the event
Then the event should be created successfully
And the event page should display the uploaded photos