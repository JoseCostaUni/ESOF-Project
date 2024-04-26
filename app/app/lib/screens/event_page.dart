import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/read%20data/firestore_read_changes.dart';
import 'package:app/features/bottomappnavigator.dart';

class EventPage extends StatefulWidget {
  final String eventId;

  EventPage({required this.eventId});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    CollectionReference event = FirebaseFirestore.instance.collection('event');
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: event.doc(widget.eventId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;

            if (data != null) {
              String? title = data['title'];
              String? location = data['location'];
              String? description = data['description'];
              String? dateTime = data['dateTime'];
              String? attendanceLimit = data['attendanceLimit'];
              String? imageUrl = data['imageUrl'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl != null) // Check if there is an image URL
                    Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  Text('Event: ${title ?? ''}'),
                  Text('Location: ${location ?? ''}'),
                  Text('Description: ${description ?? ''}'),
                  Text('Date Time: ${dateTime ?? ''}'),
                  Text('Attendance Limit: ${attendanceLimit ?? ''}'),
                ],
              );
            } else {
              return Text('Data not found');
            }
          }
          return Text('Loading...');
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}