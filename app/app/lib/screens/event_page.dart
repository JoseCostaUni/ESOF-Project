import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
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
                  AspectRatio(
                    aspectRatio: 2,
                    child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Center(child: Text('No images for this event')),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Created by: '),
                                ElevatedButton(
                                  onPressed: () {
                                    // Add code to handle the button press
                                  },
                                  child: Text('Join Event'),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              ' ${title ?? ''}',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today, //  calendar icon
                                  color: Colors.black,
                                  size: 20.0,
                                ),
                                SizedBox(width: 5.0),
                                Text('${dateTime ?? ''}'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on, //location icon
                                  color: Colors.black,
                                  size: 20.0,
                                ),
                                SizedBox(width: 5.0),
                                Text('${location ?? ''}'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.people, 
                                  color: Colors.black, 
                                  size: 20.0, 
                                ),
                                SizedBox(width: 5.0), 
                                Text('${attendanceLimit ?? ''}'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Text('Description:\n${description ?? ''}'),
                          ),
                        ],
                      ),
                    ),
                  ),
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