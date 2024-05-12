import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String messageId = "";
  String message = "";
  String senderId = "";
  Message(this.messageId, this.senderId, this.message);
}

class ChatFirestore {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getCurUserChatListSnapshot() async {
    CollectionReference eventCollection = firestore.collection("event");
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

  Future<Message> getMesssageById(String messageId) async {
    CollectionReference messageCollection = firestore.collection("Message");

    DocumentSnapshot docSnapshot = await messageCollection.doc(messageId).get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? messageData =
          docSnapshot.data() as Map<String, dynamic>?;
      if (messageData != null) {
        Message message = Message(
          messageId,
          messageData['senderId'],
          messageData['message'],
        );
        return message;
      }
    }

    return Message(messageId, "", "");
  }
}
