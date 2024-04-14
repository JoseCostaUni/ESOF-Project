import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetEvents extends StatelessWidget {
  final String documentId;
  GetEvents({required this.documentId});
  @override
  Widget build(BuildContext context) {
    CollectionReference event = FirebaseFirestore.instance.collection('event');
    return FutureBuilder<DocumentSnapshot>(
        future: event.doc(documentId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Text('Event: ${data['title']}, Location: ${data['location']}, Description: ${data['description']}, DateTime: ${data['dateTime']}, Attendance Limit: ${data['attendanceLimit']}');
          }
          return Text('Loading...');
        });
  }
}
