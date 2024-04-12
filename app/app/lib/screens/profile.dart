import 'package:app/features/bottomappnavigator.dart';
import 'package:app/firebase/firebase_auth_services.dart';
import 'package:app/screens/createevent.dart';
import 'package:app/screens/editprofile.dart';
import 'package:app/screens/homepage.dart';
import 'package:app/screens/settingpages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key, required this.title, required this.username});
  final String title;
  final String username;
  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  int _currentIndex = 3;

  FirebaseAuthService _user = FirebaseAuthService();

  String? username;

  Future<void> _loadUserName() async {
    String? userName = await _user.getcurrentUser();
    print("Username: $userName");
    setState(() {
      username = userName ??
          'Default Username'; // Usar um valor padrão se userName for nulo
    });
  }

  File? _image;
  Future<void> _loadData() async {
    await _loadUserName();
    await _loadImage();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_image != null)
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(_image!),
                      ),
                    if (_image == null)
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: Color.fromARGB(239, 255, 228, 225),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    widget.username, // Fazer a ligação à base de dados
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 145, left: 10),
                      child: Text(
                        '12', // Fazer a ligação à base de dados
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20, left: 30),
                      child: Text(
                        '2', // Fazer a ligação à base de dados
                        style: TextStyle(fontSize: 16, color: Colors.grey),
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
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 30, left: 30),
                      child: Text(
                        'Organized', // Fazer a ligação à base de dados
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 50, left: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const EditProfile()));
                        },
                        child: const Text('Edit Profile'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Share Profile'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'This is my alter-ego guebuza the goat for the win aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
                    // Fazer a ligação à base de dados
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
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
                        padding: const EdgeInsets.only(bottom: 40, left: 10),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                right: 8.0), // Add padding only to the right
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()));
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
