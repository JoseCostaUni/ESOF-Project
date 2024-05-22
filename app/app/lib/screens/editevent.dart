import 'dart:io';
import 'package:app/screens/event_page.dart';
import 'package:intl/intl.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/maps_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

class EditeventPage extends StatefulWidget {
  final String eventId;

  const EditeventPage({required this.eventId, Key? key}) : super(key: key);

  @override
  State<EditeventPage> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditeventPage> {
  int _currentIndex = 0;
  late String eventId;
  final List<String> _selectedImages = [];

  TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _attendanceLimitsController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<dynamic>? imageUrls;

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
    _loadImage();
    _loadText();
    super.initState();
  }

  List<String> deletedImageUrls = [];

  void removeImageFromCarouselAndDelete(String imageUrl) async {
    String fileName =
        imageUrl.split('%2F').last.split('?').first.replaceAll('%20', ' ');

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('event_images')
        .child(fileName);
    try {
      await ref.delete();
      print('Deleted file: $fileName');
    } catch (e) {
      print('Error deleting file: $fileName, Error: $e');
    }

    setState(() {
      imageUrls?.remove(imageUrl);
      deletedImageUrls.add(imageUrl);
      if (_selectedImages.contains(imageUrl)) {
        _selectedImages.remove(imageUrl);
      }
    });
  }

  Future<String> _uploadImageToStorage(File imageFile) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('event_images')
          .child('${DateTime.now().millisecondsSinceEpoch}');
      firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
      firebase_storage.TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls!.add(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<void> _cancelEventDetails(String eventId) async {
    if (eventId != null) {
      await FirebaseFirestore.instance.collection("event").doc(eventId).update({
        'imageUrls': FieldValue.arrayRemove(_selectedImages),
      });

      for (String imageUrl in _selectedImages) {
        String fileName =
            imageUrl.split('%2F').last.split('?').first.replaceAll('%20', ' ');

        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('event_images')
            .child(fileName);
        try {
          await ref.delete();
          print('Deleted file: $fileName');
        } catch (e) {
          print('Error deleting file: $fileName, Error: $e');
        }
      }
    }
  }

  Future<void> _updateEventDetails(String eventId) async {
    if (eventId != null) {
      for (String deletedImageUrl in deletedImageUrls) {}

      await FirebaseFirestore.instance.collection("event").doc(eventId).update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'location': _locationController.text,
        'attendanceLimit': _attendanceLimitsController.text,
        'dateTime': _dateController.text,
      });

      await FirebaseFirestore.instance.collection("event").doc(eventId).update({
        'imageUrls': FieldValue.arrayRemove(deletedImageUrls),
      });

      await FirebaseFirestore.instance.collection("event").doc(eventId).update({
        'imageUrls': FieldValue.arrayUnion(_selectedImages),
      });
    }

    for (String imageUrl in deletedImageUrls) {
      String fileName =
          imageUrl.split('%2F').last.split('?').first.replaceAll('%20', ' ');

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('event_images')
          .child(fileName);
      try {
        await ref.delete();
        print('Deleted file: $fileName');
      } catch (e) {
        print('Error deleting file: $fileName, Error: $e');
      }
    }
  }

  Future<void> _loadText() async {
    eventId = widget.eventId;
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection("event")
          .doc(eventId)
          .get();

      setState(() {
        _titleController.text = docSnapshot.get('title') ?? '';
        _dateController.text = docSnapshot.get('dateTime') ?? '';
        _locationController.text = docSnapshot.get('location') ?? '';
        _attendanceLimitsController.text =
            docSnapshot.get('attendanceLimit') ?? '';
        _descriptionController.text = docSnapshot.get('description') ?? '';
        imageUrls = docSnapshot.get('imageUrls');
      });
    } catch (e) {
      print('Failed to load profile details from Firebase Storage: $e');
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

  Future<void> _deleteEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance
          .collection('event')
          .doc(eventId)
          .delete();
      print('Evento deletado com sucesso.');
    } catch (e) {
      print('Erro ao deletar o evento: $e');
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
                                  .doc(FirebaseAuth.instance.currentUser?.email)
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
                              onPressed: () async {
                                await _deleteEvent(eventId);
                                Navigator.pop(context);
                              },
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
                            DateTime initialDateTime =
                                _dateController.text.isNotEmpty
                                    ? DateFormat('yyyy-MM-dd HH:mm')
                                        .parse(_dateController.text)
                                    : DateTime.now();
                            DateTime? dateTime = await showOmniDateTimePicker(
                              context: context,
                              initialDate: initialDateTime,
                              firstDate: DateTime(1600)
                                  .subtract(const Duration(days: 3652)),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 3652)),
                            );
                            if (dateTime != null) {
                              String formattedDateTime =
                                  DateFormat('yyyy-MM-dd HH:mm')
                                      .format(dateTime);
                              _dateController.text = formattedDateTime;
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
                              onTap: () {},
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
                                        String imageUrl =
                                            await _uploadImageToStorage(
                                                File(pickedCameraFile.path));
                                        setState(() {
                                          _selectedImages.add(imageUrl);
                                        });
                                      }
                                    } else {
                                      String imageUrl =
                                          await _uploadImageToStorage(
                                              File(pickedFile.path));
                                      setState(() {
                                        _selectedImages.add(imageUrl);
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                                const Text("Add photos"),
                                const SizedBox(width: 10),
                                Text((imageUrls?.length ?? 0).toString()),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CarouselSlider(
                          items: imageUrls?.map<Widget>((imageUrl) {
                                return Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            removeImageFromCarouselAndDelete(
                                                imageUrl);
                                          });
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList() ??
                              [],
                          options: CarouselOptions(
                            aspectRatio: 16 / 9,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await _cancelEventDetails(eventId);
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await _updateEventDetails(eventId);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EventPage(eventId: eventId),
                                  ),
                                );
                              },
                              child: const Text("Update event"),
                            ),
                          ],
                        ),
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
