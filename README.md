# _Help Buddies_ Development Report ![output-onlinepngtools](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/131660816/907044b1-9633-4905-b55f-7c15e947e7cb)

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
---
## Index

* [Business modeling](#Business-Modelling)
  * [Product Vision](#Product-Vision)
  * [Elevator Pitch](#Elevator-Pitch)
* [Requirements](#Requirements)
  * [User stories](https://github.com/orgs/FEUP-LEIC-ES-2023-24/projects/68/views/1?filterQuery=User+Story)
  * [Domain model](#Domain-Model)
* [Architecture and Design]()
  * [Logical architecture](#Logical-Architeture)
  * [Physical architecture](#Physical-Architeture)
  * [Vertical prototype](#Vertical-Prototype)
 * [Sprint 1](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/blob/main/README.md#sprint-1-app-version-101)
 * [Sprint 2](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/blob/main/README.md#sprint-2-app-version-102) 

---

## Business Modelling:

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
![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/131660816/68c24aec-6055-46ac-80f5-8966820f7c88)

* User: The user is able to see the feed, search for events and see the account's of the other users, the users can either be registered or unregistered
* Unregistered User: An unregistered user can also register an account or sign in a previously created one.
* Registered User: Registered user has an username which is used as it's tag, the full name, a profile picture, email, biography that appears in his profile and a password.
* Event: Event has idEvent(a unique identifier for each event),name(which provides a brief title for the event), description of the event( providing information about its purpose, activities, etc), location (the adress where the event will take place), image associated with the event.
* Event Administrator: The one who can manage and create the event, he is also able to kick members out of an event.
* Event member: Can join an already existing event, after being approved by the administrator.
* Messages: The event or his members can create messages that other users receive directly or undirectly through a notification.

---

## Architeture and Design

### Logical Architeture:
![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/131660816/643ec387-0691-4778-b7ec-a3492d0dff5d)

#### API's:
* Google Maps: Integration with the Google Maps API enables the app to provide interactive maps for event locations.
* Awesome Notifications: Enhances user engagement by delivering dynamic and visually appealing notifications.
* Firebase: Real-time data synchronization across multiple devices.

### Physical Architeture:
![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/131660816/bbdc0a99-0d38-4221-8fb9-1731cc1bf5c2)

#### Languages/Development kits used:
* Flutter: It allows developers to write code that can be used across multiple platforms using a single codebase, saving time and effort
* Dart: This language is highly optimized with flutter and can be used as both frontend(Flutter) and backend(Dart server), promoting consistency.
* Firebase: Firebase offers a wide amount of backend services, including real-time database, authentication, cloud storage, and hosting, simplifying backend development for Flutter apps.


## Sprint 1 (App Version 1.0.1)


### Sprint Planning

![Untitled](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/131660816/5bdc734c-c686-4680-8601-f419ebc39169)

### End of Sprint 1 Board

![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/131660816/cc788382-acba-49e2-b14a-ad7134d47f55)

### Sprint 1 Review (v1.0.1)

At first glance , the sprint went really well as almost everything that was planned got actually done , apart from some minor things that will be left for the next sprint. We were able to complete 10 user stories from the 12 that were initially planned. In retrospective , we could probably have finished all of them had we not had problemas while trying to test the current code with flutter_gherkin, tests which were rendered useless due to the dart limitations. It is also important to note that backend and testing in general is still pretty raw , as this will be the main focus in the next sprint.

To sum up, we agree that the sprint was well planned, well executed and that almost everything went according the plan.

### Happiness Meter

![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/131660816/ecbbfc50-bd06-4912-aced-0c2311046260)

### Sprint Retrospective:

#### What went well ?
- Database connection firebase working well
- UI
- Application working without any bugs
- All started user stories were completely done

#### What went wrong ?
- Tests not working the way it was intended
- We didn't focus as much in the backend
- Not included all apis used in the vertical prototype yet

#### What puzzles us ?
- The time wasted on trying to make the tests work
- The not so trivial dart language
- Database creation and connection not very easily done

#### What are we going to do to improve?
- We will try to organise the code in a better way
- Work in more focused way, since we explored the language and now we know how to work with it a little better

## Sprint 2 (App Version 1.0.2)

### Sprint Planning

![Screenshot from 2024-04-27 14-35-52](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/131660816/0d4cafa5-3f89-4ed6-8799-b6a1aeb83660)

### End of Sprint 2 Board

![Screenshot from 2024-04-30 10-51-56](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/131660816/b7abf97c-8754-4f0c-a8e5-fdb28bddab8d)

### Sprint 2 Review (v1.0.1)

At first glance , the sprint went better than the first one , since almost all planned increments were actually implemented , apart from some minor tweaks that will be left for the next sprint. We were able to complete 15 features from the 11 that were initially planned. Summarizing, we could probably have done further progress but we had lots of other side projects and tests that difficulted our full focus in this sole project, but we are optimistic of our progress and our method/organization, in the end, it went smoothly and was all according to the plan.

### Happiness Meter
![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/131660816/46bd353e-f698-412c-b4a5-f942a3e05137)
