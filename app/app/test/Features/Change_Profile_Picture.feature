Feature: Profile Picture Change


    Scenario: User changes their profile picture
        Given the user is logged into the app
        When the user navigates to the account settings
        And selects the option to change their profile picture
        Then the system should allow the user to upload a new profile picture from their device
        And display a preview of the selected profile picture
        And provide an option to crop or adjust the profile picture if necessary
        And upon confirmation, update the user's profile picture in the system
        And display a message confirming the successful profile picture change

    Scenario: User cancels profile picture change
        Given the user is on the profile picture change page
        When the user decides to cancel the profile picture change action
        Then the system should return the user to the account settings page
        And no changes should be made to the user's profile picture

    Scenario: User selects an invalid profile picture file
        Given the user is on the profile picture change page
        When the user attempts to upload a file that is not an image or exceeds file size limits
        Then the system should display an error message indicating that the selected file is invalid
        And prompt the user to select a valid image file within the specified size limits