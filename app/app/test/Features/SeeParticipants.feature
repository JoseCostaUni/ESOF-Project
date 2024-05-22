Feature: See Participants
    As a owner of the event
    I want to see the list of participants in an event

    Scenario: Viewing the list of participants
        Given I am on the event page
        When I click on the "person icon" 
        Then I should see a list of participants
        And the list should include the following participants:
            | Name          
            | John Doe      
            | Jane Smith    
            | Mark Johnson  