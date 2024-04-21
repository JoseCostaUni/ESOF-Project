Feature: Send Message to Event Group Chats

Scenario: User sends a message to all event group chats successfully
Given the user is logged in
When the user navigates to their enrolled events
And selects the option to send a message to all event group chats
And enters a message
And sends the message
Then the message should be successfully sent to all event group chats
And all participants in the group chats should receive the message

Scenario: User attempts to send empty message to all event group chats
Given the user is logged in
When the user navigates to their enrolled events
And selects the option to send a message to all event group chats
And leaves the message field empty
And attempts to send the message
Then an error message should be displayed indicating that the message cannot be empty
And the message should not be sent