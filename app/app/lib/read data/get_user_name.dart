import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class getusername extends StatelessWidget {
  final String documentId;

  getusername({required this.documentId})
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(builder: ((context, Snapshot){
      if (Snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data = Snapshot.data!.data() as Map<String, dynamic> ;
        return Text('name: ${data['name']}');

      }
      return Text('loading');
    }), future: null,);
  }
}
