import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreReadData  {
  User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference event =
      FirebaseFirestore.instance.collection("event");

  Future<Future<DocumentReference<Object?>>> addEvent(String message, DateTime chosenDate, String location, int atendace, String descri, File imageFile) async {
      String imageUrl = await _uploadImage(imageFile);

    return event.add({
      'event title' : message,
      "date time" : chosenDate,
      'Location' : location,
      "attendace limit" : atendace,
      "decription": descri,
      'image_url': imageUrl,
    });
  }
   Future<String> _uploadImage(File imageFile) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('event_images/${DateTime.now().millisecondsSinceEpoch}');

    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  Stream<QuerySnapshot> getpoststream() {
    final poststream =
        FirebaseFirestore.instance.collection('event').orderBy("event title", descending: false).snapshots();
    return poststream;
  }
}
