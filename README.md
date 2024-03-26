# _Help Buddies_ Development Report

Welcome to the documentation pages of the _Help Buddies_!

Initially, contributions are anticipated to originate solely from the founding team. However, following the ES class program's completion, we aim to extend participation to the broader community across various domains and subjects, encompassing requirements, technologies, development, experimentation, testing, and more.

Don't hesitate to contact us for any changes you think are healthy for the development of the full extent of the app!

Best regards, 2LEIC04T4

### Membros

1. José Costa - up202207871 
2. Bruno Fortes - up202209730
4. Diogo Leandro - up202005304
3. Ângelo Oliveira - up202207798
5. Carolina Almeida - up202108757

* Business modeling(#Business-Modelling)
  * [Product Vision](#Product-Vision)
  * [Elevator Pitch](#Elevator-Pitch)
* [Requirements](#Requirements)
  * [User stories](#https://github.com/orgs/FEUP-LEIC-ES-2023-24/projects/68)
  * [Domain model](#Domain-Model)
* [Architecture and Design]()
  * [Logical architecture](#Logical-Architeture)
  * [Physical architecture](#Physical-Architeture)
  * [Vertical prototype](#Vertical-Prototype)

---

## Business Modelling

### Product Vision:

Are you an advocate for sustainability and enjoy connecting with like-minded individuals? HelpBuddies is the ultimate app for eco-conscious socializing! With HelpBuddies, you can easily discover and participate in a variety of sustainable events, or take the lead by creating your own eco-friendly gatherings.

### Features and Assumptions:
#### 1. User Experience:
* Intuitive User Interface: Ensure the app's interface is user-friendly and easy to navigate.
* Personalization: Allow users to customize their profiles and preferences.
* Notifications: Implement push notifications to keep users informed about events, account activities, etc.
* Create Events: Allow users to create new events within the app. 
* Event Details: Provide fields for event managers to enter event details such as title, description, date, time, location, capacity and uploading images.
#### 2. Security:
* Data Encryption: Encrypt sensitive user data to ensure privacy and security.
* Account Security: Implement secure authentication mechanisms to protect user accounts.
#### 3. Performance:
* Fast Loading: Optimize app performance to minimize loading times and provide a smooth user experience across all devices.
* Scalability: Design the app to handle a large number of users and events without performance degradation
#### 4. Community Engagement:
* Social Integration: Allow users to share events or invite friends via social media platforms.

---

## Requirements:

### Domain Model:
![ClassDiagram.drawio](https://hackmd.io/_uploads/r1NIdPe1R.png)

* User: The user is able to see the feed, search for events and see the account's of the other users, the users can either be registered or unregistered
* Unregistered User: An unregistered user can also register an account or sign in a previously created one.
* Registered User: Registered user has an username which is used as it's tag, the full name, a profile picture, email, biography that appears in his profile and a password.
* Event: Event has idEvent(a unique identifier for each event),name(which provides a brief title for the event), description of the event( providing information about its purpose, activities, etc), location (the adress where the event will take place), image associated with the event.
* Event Administrator: The one who can manage and create the event, he is also able to kick members out of an event.
* Event member: Can join an already existing event, after being approved by the administrator.
* Messages: The event or his members can create messages that other users receive directly or undirectly through a notification.

## Architeture and Design

### Logical Architeture:
![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/131660816/643ec387-0691-4778-b7ec-a3492d0dff5d)

### Physical Architeture:
![Component_Diagram.drawio](https://hackmd.io/_uploads/SJTl_ve1R.png)



