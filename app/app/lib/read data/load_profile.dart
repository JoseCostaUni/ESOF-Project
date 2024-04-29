import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<void> uploadImageToFirebaseStorage(File imageFile) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(user!.uid + '.jpg');

    await ref.putFile(imageFile);

  } catch (e) {
    print('Error uploading image to Firebase Storage: $e');
    throw e; // Optionally rethrow the error for handling elsewhere
  }
}
