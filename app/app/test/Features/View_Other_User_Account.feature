Feature: View Other Users' Accounts


    Scenario: User views another user's profile
        Given the user is logged in
        When the user navigates to view another user's profile
        Then the system should display the profile information of the other user

    Scenario: User searches for other users
        Given the user is logged in
        When the user performs a search for other users
        Then the system should display a list of matching user accounts

    Scenario: User navigates to other user's profile from event signup
        Given the user is logged in
        When the user signs up for an event
        And the event involves other users
        Then the system should provide a link to view the profiles of those users

    Scenario: User views other user's posted events
        Given the user is logged in
        When the user views another user's profile
        Then the system should display the events posted by that user

    Scenario: User tries to access restricted functionality of other user's accounts
        Given the user is logged in
        When the user tries to perform actions such as editing or deleting another user's account
        Then the system should deny access and display an error message