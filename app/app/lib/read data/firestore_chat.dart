import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirestore {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference eventCollection =
      FirebaseFirestore.instance.collection("event");
  CollectionReference messageCollection =
      FirebaseFirestore.instance.collection("Message");
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future<List<Map<String, dynamic>>> getCurUserChatListSnapshot() async {
    QuerySnapshot querySnapshot_2 = await eventCollection
        .where('eventosInscritos',
            arrayContains: FirebaseAuth.instance.currentUser!.email)
        .get();
    QuerySnapshot querySnapshot_1 = await eventCollection
        .where('userEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    return querySnapshot_1.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList() +
        querySnapshot_2.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
  }

  Future<Map<String, dynamic>> getUserDataById(String userId) async {
    DocumentSnapshot docSnapshot = await userCollection.doc(userId).get();
    return docSnapshot.data() as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMesssageDataById(String messageId) async {
    DocumentSnapshot docSnapshot = await messageCollection.doc(messageId).get();
    return docSnapshot.data() as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getEventDataById(String eventId) async {
    DocumentSnapshot docSnapshot = await eventCollection.doc(eventId).get();
    return docSnapshot.data() as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getEventMessageData(String eventId) async {
    QuerySnapshot querySnapshot = await messageCollection
        .where('eventId', isEqualTo: eventId)
        .orderBy('sent')
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Stream<List<Map<String, dynamic>>> getEventMessageStream(String eventId) {
    return messageCollection
        .where('eventId', isEqualTo: eventId)
        .orderBy('sent')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  Future<void> storeMessage(String message, String eventId) async {
    await messageCollection.add({
      'eventId': eventId,
      'message': message,
      'sent': DateTime.now(),
      'userId': FirebaseAuth.instance.currentUser!.email,
    });
  }
}
