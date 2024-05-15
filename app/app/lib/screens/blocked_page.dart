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
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    iconSize: 50,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 220.0),
                      child: IconButton(
                        iconSize: 50.0,
                        icon: Icon(Icons.add_outlined),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ))
                ],
              ),
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.email).get(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
                    List<String> blockedUsers = data != null && data['blocked'] != null ? List<String>.from(data['blocked']) : [];
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: blockedUsers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(blockedUsers[index]),
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
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
