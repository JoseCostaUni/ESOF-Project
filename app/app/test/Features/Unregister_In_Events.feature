Feature: Unregister in Events


    Scenario: User unregisters from an event successfully
        Given the user is logged in
        And the user is registered for an upcoming event
        When the user selects the event to unregister
        And clicks on the unregister button
        Then the system should remove the user from the list of participants for the event
        And display a confirmation message

    Scenario: User attempts to unregister from an event without logging in
        Given the user is not logged in
        And the user is registered for an upcoming event
        When the user tries to unregister from the event
        Then the system should prompt the user to log in first

    Scenario: User attempts to unregister from an event they are not registered for
        Given the user is logged in
        And the user is not registered for any upcoming event
        When the user tries to unregister from an event
        Then the system should inform the user that they are not registered for the event