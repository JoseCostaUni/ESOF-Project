import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationState extends StatelessWidget {
  const NotificationState({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentuser = FirebaseAuth.instance.currentUser;

    Future<DocumentSnapshot<Map<String, dynamic>>> getuserdetails() async {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(currentuser!.email)
          .get();
    }

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getuserdetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            Map<String, dynamic>? user = snapshot.data!.data();
            if (user != null && user.containsKey('name')) {
              return Column(
                children: [Text(user!['name'])],
              );
            } else {
              // Handle case where user data is null or does not contain the key 'name'
              return const Text("User data unavailable");
            }
          } else {
            return const Text("No data");
          }
        },
      ),
    );
  }
}
