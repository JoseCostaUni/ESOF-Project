Feature: Biography Update

    Scenario: User updates biography successfully
        Given the user is logged in
        When the user navigates to their profile settings
        And selects the option to edit biography
        And enters a new biography
        And saves the changes
        Then the biography should be updated successfully

    Scenario: User cancels biography update
        Given the user is logged in
        When the user navigates to their profile settings
        And selects the option to edit biography
        And enters a new biography
        And cancels the changes
        Then the biography should remain unchanged

    Scenario: User updates biography with empty field
        Given the user is logged in
        When the user navigates to their profile settings
        And selects the option to edit biography
        And leaves the biography field empty
        And saves the changes
        Then an error message should be displayed indicating the biography field cannot be empty
        And the biography should remain unchanged

    Scenario: User updates biography exceeding character limit
        Given the user is logged in
        When the user navigates to their profile settings
        And selects the option to edit biography
        And enters a biography exceeding the character limit
        And saves the changes
        Then an error message should be displayed indicating the character limit is exceeded
        And the biography should remain unchanged