import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventHandler {
  List<Map<String, dynamic>> eventsArray = [];
  Map<String, Map<String, dynamic>> eventsMap = {};
  Map<String, Map<String, dynamic>> usersMap = {};
  List<Map<String, dynamic>> suggestions = [];
  List<String> eventsID = [];
  List<Map<String, dynamic>> events = [];
  List<Map<String, dynamic>> Allusers = [];

  Future<List<Map<String, dynamic>>> getAllEvents() async {
    List<Map<String, dynamic>> events = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('event').get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> eventData = doc.data();
      events.add(eventData);
    });

    eventsArray = events;

    return events;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    List<Map<String, dynamic>> users = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> userData = doc.data();
      users.add(userData);
    });

    Allusers = users;

    return Allusers;
  }

  Future<Map<String, dynamic>> getEventById(String eventId) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('event').doc(eventId).get();

    return documentSnapshot.data()!;
  }

  Future<void> createEvent(Map<String, dynamic> eventData) async {
    await FirebaseFirestore.instance.collection('event').add(eventData);
  }

  Future<void> updateEvent(
      String eventId, Map<String, dynamic> eventData) async {
    await FirebaseFirestore.instance
        .collection('event')
        .doc(eventId)
        .update(eventData);
  }

  Future<void> deleteEvent(String eventId) async {
    await FirebaseFirestore.instance.collection('event').doc(eventId).delete();
  }

  Future<String> uploadImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child('event_images/$fileName');
    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> deleteImage(String imageUrl) async {
    Reference reference = FirebaseStorage.instance.refFromURL(imageUrl);
    await reference.delete();
  }

  Future<void> attendEvent(String eventId) async {
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('event').doc(eventId).update({
      'attendees': FieldValue.arrayUnion([user!.uid])
    });
  }

  List<Map<String, dynamic>> getEvents() {
    return events;
  }

  Future<List<Map<String, dynamic>>> calcUsers(String input) async {
    if (input.isNotEmpty) {
      List<Map<String, dynamic>> recommendations = [];
      List<String> usersNames = [];
      Map<String, Map<String, dynamic>> usersMap = {};

      List<Map<String, dynamic>> allEvents = await getAllUsers();

      for (var event in allEvents) {
        String name = event['name'];
        name = name.toLowerCase();
        usersNames.add(name);
        usersMap[name] = event;
      }

      if (input.isNotEmpty) {
        input = input.toLowerCase();

        usersNames = usersNames.map((item) => item.toLowerCase()).toList();

        List<String> filteredUsers =
            usersNames.where((user) => user.startsWith(input)).toList();

        usersNames =
            usersNames.where((item) => !item.startsWith(input)).toList();

        Map<String, int> suggestionsMap = {};
        filteredUsers.forEach((user) {
          int differences = 0;
          for (int i = 0; i < input.length; i++) {
            if (user[i] != input[i]) {
              differences++;
            }
          }
          suggestionsMap[user] = differences;
        });

        List<String> sortedUsers = filteredUsers
          ..sort((a, b) =>
              (a.length - input.length).abs() -
              (b.length - input.length).abs());

        List<MapEntry<String, int>> sortedMap = suggestionsMap.entries.toList()
          ..sort((a, b) => a.value - b.value);

        List<String> result = [];
        result.addAll(sortedUsers);
        result.addAll(sortedMap.map((user) => user.key));

        result = result.toSet().toList();

        for (String name in result) {
          recommendations.add(usersMap[name]!);
        }
      }

      suggestions = recommendations;
    } else {
      suggestions = [];
    }

    events = [...suggestions];

    return events;
  }

  Future<List<Map<String, dynamic>>> calcEvents(String input) async {
    if (input.isNotEmpty) {
      List<Map<String, dynamic>> recommendations = [];
      List<String> itemNames = [];
      Map<String, Map<String, dynamic>> eventsMap = {};

      List<Map<String, dynamic>> allEvents = await getAllEvents();

      for (var event in allEvents) {
        String title = event['title'];
        title = title.toLowerCase();
        itemNames.add(title);
        eventsMap[title] = event;
      }

      if (input.isNotEmpty) {
        input = input.toLowerCase();

        itemNames = itemNames.map((item) => item.toLowerCase()).toList();

        List<String> filteredItems =
            itemNames.where((item) => item.startsWith(input)).toList();

        itemNames = itemNames.where((item) => !item.startsWith(input)).toList();

        Map<String, int> suggestionsMap = {};
        filteredItems.forEach((item) {
          int differences = 0;
          for (int i = 0; i < input.length; i++) {
            if (item[i] != input[i]) {
              differences++;
            }
          }
          suggestionsMap[item] = differences;
        });

        List<String> sortedItems = filteredItems
          ..sort((a, b) =>
              (a.length - input.length).abs() -
              (b.length - input.length).abs());

        List<MapEntry<String, int>> sortedMap = suggestionsMap.entries.toList()
          ..sort((a, b) => a.value - b.value);

        List<String> result = [];
        result.addAll(sortedItems);
        result.addAll(sortedMap.map((item) => item.key));

        result = result.toSet().toList();

        for (String name in result) {
          recommendations.add(eventsMap[name]!);
        }
      }

      suggestions = recommendations; // Update suggestions with the latest data
    } else {
      suggestions = []; // Clear suggestions if input is empty
    }

    events = [...suggestions]; // Update events with the latest suggestions

    return events;
  }
}
