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
 * [Sprint 3](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/blob/main/README.md#sprint-3-app-version-103)

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

### Sprint Retrospective:

#### What went well ?
- We fixed the issues with the remote database not being able to store/display images it in a correct way.
- We were able to do more work than what we expected in the start of sprint.
- All the group members did what they were destined to do, with a lot of spare time.

#### What went wrong ?
- We didn't add the .feature files to the issues.
- We forgot to create the issues in some work items/user stories and they were kept as draft issues only.
- The events were order by the event creation date and not by the event actual date.
- We didn't assign any work item/user story to more than one member, so none of them were made with a actual person that only coded and one that only reviewed the code.

#### What puzzles us ?
- Adding more than one image to a certain event
- Search bar algorithm was not so trivial and took a lot more effort than expected
- Downloading images from database to local to be able to display them with a specified flutter widget, so we went with another route

#### What are we going to do to improve?
- Divide the work in a way that groups of 2/3 are assigned to each task
- Organise/Write code in a way that in the end leads to a lot less polishing needed
- Explore and research more options to test certain functions with other libraries

### Happiness Meter
![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/94701253/ce3b29bf-895c-48f2-867a-107fa28cf514)

## Sprint 3 (App Version 1.0.3)

### Sprint Planning

![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/131660816/42c7befb-01e4-4358-b5a1-7f1c94de4f4d)

### End of Sprint 3 Board

![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/131660816/9c5fda20-6159-4282-80c9-a59b85ec4258)

### Sprint 3 Review (v1.0.3)

In this sprint, our team performed exceptionally well, successfully implementing all the planned increments. We completed every feature we set out to achieve, demonstrating excellent teamwork and organization throughout the process.
Despite the challenges of balancing this project with numerous side projects and tests, our focus and collaboration ensured that everything went smoothly and according to plan. The cohesive effort of the team was evident in the way we managed to tackle all tasks efficiently.
Overall, we are very pleased with our progress and the methods we employed. This sprint has shown that our strategies are effective and that we can achieve our goals even when faced with additional responsibilities.

### Happiness Meter

![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T4/assets/131660816/ce45b390-c306-4a9c-86eb-9dbd22b0665a)

### Sprint Retrospective:

#### What went well ?
- We were able to finish all the ideas we had prepared for the app.
- We successfully integrated feedback from previous sprints.
- We fixed the issues related to searching for other users in search bar would redirect to a printscreen instead of a page.
- The team worked together in groups of 2, to make the code development faster and to avoid possible lapses.
- Code reviews were thorough and constructive, leading to higher quality and more maintainable code.
- We added .features files to every issue we created and made acceptance tests for each one.

#### What went wrong ?
- We weren't able to finish the notifications on time given it's difficulty to implement.
- Some team members faced difficulties with merging code, which caused delays and additional work.

#### What puzzles us ?
- Chat messages for each event were difficult to make, causing 2 people to take more time to focus on that task to complete it thoroughly.
- We encountered unexpected behavior in third-party Flutter packages, which led to additional debugging and troubleshooting time and in the end those packages were substituted or not used at all.

#### What are we would do to improve the app in the future if we had more time?
- Notifications for when a user received an event related message or an event that he/she is subscribed was deleted/edited.
- UI changes to make the app look more uniform in all the pages, even in the ones that had a lot less use than the others.
- Create unit test to ensure coverage and to identify and fix bugs earlier in the development process, improving overall app stability.
- Improve the search functionality to be faster and more accurate, with better filtering and sorting options, in case the user misspelled.
- Introduce accessibility features to make the app usable for people with disabilities, such as voice commands and high contrast modes.
- Integrate social media sharing and authentication to allow users to easily share events or invite friends to join the app. 





