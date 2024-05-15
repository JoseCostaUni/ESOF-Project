import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersPage extends StatefulWidget {
  final String eventId;

  UsersPage({required this.eventId});

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late String host;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users Attending'),
        
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('event')
            .doc(widget.eventId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            var data = snapshot.data?.data() as Map<String, dynamic>?; 
            var attendees = data?['eventosInscritos'] as List<dynamic>? ?? []; 

            return ListView.builder(
              itemCount: attendees.length,
              itemBuilder: (context, index) {
                var userId = attendees[index];
                return ListTile(
                  title: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .get(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        var userData = snapshot.data?.data() as Map<String, dynamic>?; 
                        var userName = userData?['username'] ?? 'Unknown';

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(userName),
                            IconButton(
                              icon: Icon(Icons.remove_circle),
                              onPressed: () {
                                removeUserFromEvent(userId);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.star),
                              onPressed: () {
                                setHost(userId);
                              },
                            ),
                          ],
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void removeUserFromEvent(String userId) {
    FirebaseFirestore.instance
        .collection('event')
        .doc(widget.eventId)
        .update({
      'eventosInscritos': FieldValue.arrayRemove([userId]),
    });
  }

  void setHost(String userId) {
    setState(() {
      host = userId;
    });

    FirebaseFirestore.instance
        .collection('event')
        .doc(widget.eventId)
        .update({
      'host': userId,
    });
  }
}
