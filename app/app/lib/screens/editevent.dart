import 'dart:io';
import 'package:intl/intl.dart';

import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/maps_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class EditeventPage extends StatefulWidget {
  const EditeventPage({super.key});

  @override
  State<EditeventPage> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditeventPage> {
  int _currentIndex = 0;

  Future<String> getUserProfilePicture(String userEmail) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return userData['profilepicture'] ?? 'default_picture_url';
  }

  String __image = '';
  File? _image;
  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadText() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final querySnapshot =
            await FirebaseFirestore.instance.collection("event").get();

        // Aqui você precisa decidir como deseja lidar com múltiplos documentos
        // Vou apenas usar o primeiro documento encontrado como exemplo
        final docSnapshot =
            querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first : null;

        if (docSnapshot != null) {
          setState(() {
            final TextEditingController _nameController2 =
                TextEditingController(text: docSnapshot['title']);
            final TextEditingController _usernameController2 =
                TextEditingController(text: docSnapshot['username']);
            final TextEditingController _descriptionController2 =
                TextEditingController(text: docSnapshot['description']);

            _titleController = _nameController2;
            //_usernameController = _usernameController2;
            //_descriptionController = _descriptionController2;
          });
        }
      } catch (e) {
        print('Failed to load profile details from Firebase Storage: $e');
      }
    }
  }

  Future<void> _loadImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.email)
            .get();
        final String imageUrl = docSnapshot.get('profilepicture');
        if (imageUrl.isNotEmpty) {
          setState(() {
            __image = imageUrl;
          });
        }
      } catch (e) {
        print('Failed to load image from Firebase Storage: $e');
      }
    }
  }

  TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _attendanceLimitsController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<File> _selectedImages = [];
  Future<void> updateOrganizedEventsCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.email);
      await userRef.update({
        'organizedEventsCount': FieldValue.increment(1),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 191, 180),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 20.0),
                    const Text(
                      'Edit Event',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 4,
                  color: const Color.fromARGB(255, 243, 190, 177),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: _image != null
                                    ? Image.network(
                                        __image,
                                        fit: BoxFit.cover,
                                      )
                                    : FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.email)
                                            .get(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                "Error: ${snapshot.error}");
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            Map<String, dynamic> data =
                                                snapshot.data!.data()
                                                    as Map<String, dynamic>;
                                            final profilePictureUrl =
                                                data['profilepicture'];
                                            if (profilePictureUrl != null) {
                                              return Image.network(
                                                profilePictureUrl,
                                                fit: BoxFit.cover,
                                              );
                                            }
                                          }

                                          return Container(
                                            color: Colors.grey[200],
                                          );
                                        },
                                      ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth
                                      .instance.currentUser?.email)
                                  .get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Error: ${snapshot.error}");
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> data = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  return Text(
                                    data['username'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  );
                                }

                                return const CircularProgressIndicator();
                              },
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Delete event'),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: 'Event Title',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 167, 166, 166),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            DateTime? dateTime = await showOmniDateTimePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime(1600).subtract(const Duration(days: 3652)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 3652)),
                            );
                            if (dateTime != null) {
                              String formattedDateTime =
                                  DateFormat('yyyy-MM-dd HH:mm')
                                      .format(dateTime);
                              setState(() {
                                _dateController.text = formattedDateTime;
                              });
                            }
                          },
                          child: TextField(
                            controller: _dateController,
                            decoration: const InputDecoration(
                              hintText: 'Select Date and Time',
                              prefixIcon: Icon(Icons.calendar_today),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            enabled: false,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            hintText: 'Location',
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 167, 166, 166),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            disabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            prefixIcon: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MapsScreen(),
                                  ),
                                );
                              },
                              child: const Icon(Icons.location_on_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _attendanceLimitsController,
                          decoration: const InputDecoration(
                            hintText: 'Attendance limit',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 167, 166, 166),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Events Description',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 167, 166, 166),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    final pickedFile = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    if (pickedFile == null) {
                                      final pickedCameraFile =
                                          await ImagePicker().pickImage(
                                              source: ImageSource.camera);
                                      if (pickedCameraFile != null) {
                                        setState(() {
                                          _selectedImages.add(File(
                                              pickedCameraFile.path));
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        _selectedImages
                                            .add(File(pickedFile.path));
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                                const Text("Add photos"),
                                const SizedBox(width: 10),
                                Text(_selectedImages.length.toString()),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () async {},
                              child: const Text("Update event"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
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
