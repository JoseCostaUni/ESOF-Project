Feature: Unregister in Events

    Scenario: User unregisters from an event successfully
        Given the user is logged in
        And the user is registered for an upcoming event
        When the user selects the event to unregister
        And clicks on the unregister button
        Then the system should remove the user from the list of participants for the event
        And display a confirmation message
