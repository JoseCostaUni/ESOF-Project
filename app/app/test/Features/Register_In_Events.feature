Feature: Register in Events


    Scenario: User registers for an event successfully
        Given the user is logged in
        And there is an upcoming event available
        When the user selects the desired event to register
        And clicks on the register button
        Then the system should add the user to the list of participants for the event
        And display a confirmation message

    Scenario: User attempts to register for an event that is already full
        Given the user is logged in
        And there is an upcoming event available
        And the event has reached its maximum capacity
        When the user tries to register for the event
        Then the system should inform the user that the event is already full