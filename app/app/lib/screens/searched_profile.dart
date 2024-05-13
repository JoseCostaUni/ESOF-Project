import 'package:app/features/bottomappnavigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:app/features/bottomappnavigator.dart';
import 'package:app/screens/editprofile.dart';
import 'package:app/screens/settingpages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchedProfile extends StatefulWidget {
  final Map<String, dynamic> user;

  // Constructor with named parameter user
  const SearchedProfile({
    Key? key,
    required this.user,
  }) : super(key: key); // Call the super constructor

  @override
  State<StatefulWidget> createState() => _SearchedProfileState();
}

class BlockUnblockButton extends StatefulWidget {
  final String userEmail;

  BlockUnblockButton({required this.userEmail});

  @override
  _BlockUnblockButtonState createState() => _BlockUnblockButtonState();
}

class _BlockUnblockButtonState extends State<BlockUnblockButton> {
  bool isBlocked = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.email).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
          isBlocked = data != null && data['blocked'] != null && data['blocked'].contains(widget.userEmail);
          return ElevatedButton(
            onPressed: () async {
              String? currentUser = FirebaseAuth.instance.currentUser?.email;
              if (currentUser != null) {
                if (isBlocked) {
                  await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser)
                    .update({
                      'blocked': FieldValue.arrayRemove([widget.userEmail])
                    });
                } else {
                  await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser)
                    .update({
                      'blocked': FieldValue.arrayUnion([widget.userEmail])
                    });
                }
                setState(() {
                  isBlocked = !isBlocked;
                });
              }
            },
            child: Text(isBlocked ? 'Unblock User' : 'Block User'),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class _SearchedProfileState extends State<SearchedProfile> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user = widget.user;

    return Scaffold(
      backgroundColor: Color.fromARGB(239, 255, 228, 225),
      body: Stack(
        children: [
          Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    // Profile Picture
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        user['profilepicture'] ?? '',
                      ),
                    ),
                    SizedBox(height: 20),
                    // User Name
                    Text(
                      user['name'] ?? '',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Placeholder for number of participations
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '12', // Placeholder for number of participations
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Participations',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Placeholder for number of organized events
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '2', // Placeholder for number of organized events
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Organized',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Buttons for Edit Profile and Share Profile
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 50, left: 10),
                          child: BlockUnblockButton(userEmail: user['email']),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10, left: 10),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Share Profile'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Placeholder for user description
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'User Description', // Placeholder for user description
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Placeholder for last attended events
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'Last Attended Events:', // Placeholder for last attended events
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Placeholder for last attended events list
                    Container(
                      width: 300,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(239, 255, 228, 225),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 40, left: 10),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.0),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  'Event Name', // Placeholder for event name
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Event Location', // Placeholder for event location
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
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
