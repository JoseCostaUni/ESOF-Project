import 'dart:async';

import 'package:app/features/bottomappnavigator.dart';
import 'package:app/read%20data/firestore_read_changes.dart';
import 'package:app/screens/editprofile.dart';
import 'package:app/screens/settingpages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key, required this.title, required this.username})
      : super(key: key);
  final String title;
  final String username;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  int _currentIndex = 3;

  String? username;
  List<String> docid = [];

  User? currentuser = FirebaseAuth.instance.currentUser;

  File? _image;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');

    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Future<String> getUsername() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(_currentuser!.email)
        .get();
    if (snapshot.exists) {
      return snapshot.data()?['username'] ?? '';
    } else {
      return '';
    }
  }


  Future<String> getUserDescription() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(_currentuser!.email)
        .get();
    if (snapshot.exists) {
      return snapshot.data()?['description'] ?? '';
    } else {
      return '';
    }
  }

  final FirestoreReadData _description = FirestoreReadData();

  final User? _currentuser = FirebaseAuth.instance.currentUser;
  Future<DocumentSnapshot<Map<String, dynamic>>> getuserdetails() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentuser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: Stack(
        children: [
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: _image != null
                                        ? Image.file(
                                            _image!,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: const Color.fromARGB(
                                                239, 255, 228, 225),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: FutureBuilder<String>(
                                future: getUsername(),
                                builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return Text(
                                          "Error: ${snapshot.error}");
                                    }
                                    String description =
                                        snapshot.data ?? "No description";
                                    return Padding(
                                      padding: const EdgeInsets.all(25),
                                      child: Text(description),
                                    );
                                  }),),
                            const SizedBox(height: 10),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 145, left: 10),
                                  child: Text(
                                    '12', // Fazer a ligação à base de dados
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20, left: 30),
                                  child: Text(
                                    '2', // Fazer a ligação à base de dados
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 70, left: 10),
                                  child: Text(
                                    'Participations', // Fazer a ligação à base de dados
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: Text(
                                    'Organized', // Fazer a ligação à base de dados
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 50, left: 10),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const EditProfile()));
                                    },
                                    child: const Text('Edit Profile'),
                                  ),
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
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: FutureBuilder<String>(
                                  future: getUserDescription(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return Text(
                                          "Error: ${snapshot.error}");
                                    }
                                    String description =
                                        snapshot.data ?? "No description";
                                    return Padding(
                                      padding: const EdgeInsets.all(25),
                                      child: Text(description),
                                    );
                                  }),
                            ),
                            const SizedBox(height: 15),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Text(
                                'Last Attended Events:',
                                // Fazer a ligação à base de dados
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: 300,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(239, 255, 228, 225),
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 40, left: 10),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  const Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          'Palestra sobre música clássica',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Casa da Música de Maputo',
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
                  );
                } else {
                  return const Text("User data unavailable");
                }
              } else {
                return const Text("No data");
              }
            },
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
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
