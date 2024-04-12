import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Error during sign up: $e");
      return null;
    }
    //add user details
  }

  Future adduserdetails(String name, String surname, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'name': name,
      'surname': surname,
      'email': email,
    });
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Error during sign in: $e");
      return null;
    }
  }

  Future<String?> getcurrentUser() async {
    try {
      User? name = _auth.currentUser;
      return name?.displayName;
    } catch (e) {
      print("no name: $e");
      return null;
    }
  }
}
