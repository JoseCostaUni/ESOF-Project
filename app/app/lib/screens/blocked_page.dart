import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlockedPage extends StatefulWidget {
  const BlockedPage({super.key});

  @override
  State<BlockedPage> createState() => _BlockedPageState();
}

class _BlockedPageState extends State<BlockedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 241, 238),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 20), 
                  Text(
                    'Blocked Users',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Flexible(
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.email).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
                      List<String> blockedUsers = data != null && data['blocked'] != null ? List<String>.from(data['blocked']) : [];
                      return ListView.builder(
                        itemCount: blockedUsers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection('users').doc(blockedUsers[index]).get(),
                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasData) {
                                Map<String, dynamic>? userData = snapshot.data?.data() as Map<String, dynamic>?;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 4,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(userData?['profilepicture'] ?? 'default_image_url'),
                                        radius: 20,
                                      ),
                                      title: Text(userData?['name'] ?? ''),
                                      trailing: ElevatedButton(
                                        onPressed: () async {
                                          String? currentUser = FirebaseAuth.instance.currentUser?.email;
                                          if (currentUser != null) {
                                            await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(currentUser)
                                              .update({
                                                'blocked': FieldValue.arrayRemove([blockedUsers[index]])
                                              });
                                            setState(() {
                                              blockedUsers.removeAt(index);
                                            });
                                          }
                                        },
                                        child: Text('Unblock'),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Text('User data not found'),
                                );
                              }
                            },
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('No blocked users found'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}