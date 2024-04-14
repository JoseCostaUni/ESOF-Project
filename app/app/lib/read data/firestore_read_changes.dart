import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreReadData  {
  User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference description =
      FirebaseFirestore.instance.collection("description");

  Future<void> addDescription(String message) {
    return description.add({
      "description": message,
    });
  }

  Stream<QuerySnapshot> getDescription() {
    final Description =
        FirebaseFirestore.instance.collection('description').snapshots();
    return Description;
  }
}
