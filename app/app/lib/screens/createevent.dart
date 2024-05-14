import 'dart:io';
import 'package:app/features/autocompletelocation.dart';
import 'package:app/features/maps_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:app/features/bottomappnavigator.dart';
import 'package:app/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String locationName = "";
  int _currentIndex = 1;
  List<File> _selectedImages = [];
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
  void initState() {
    super.initState();
    _loadImage();
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

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _attendanceLimitsController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;
  String __image = '';

  Future<String> getUserProfilePicture(String userEmail) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return userData['profilepicture'] ?? 'default_picture_url';
  }

  Future<String?> _uploadImageToFirebaseStorage(File imageFile) async {
    try {
      // Crie uma referência para o local onde deseja armazenar a imagem no Firebase Storage
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('event_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');

      // Faça o upload do arquivo para o Firebase Storage
      await ref.putFile(imageFile);

      // Obtenha a URL da imagem carregada
      final imageUrl = await ref.getDownloadURL();

      // Retorne a URL da imagem
      return imageUrl;
    } catch (e) {
      print('Erro ao fazer upload da imagem para o Firebase Storage: $e');
      return null;
    }
  }

  Future<void> _createEvent() async {
    if (_titleController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _attendanceLimitsController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      return;
    }

    // Obtenha o usuário atualmente autenticado
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        List<String> imageUrls = [];
        for (File imageFile in _selectedImages) {
          String? imageUrl = await _uploadImageToFirebaseStorage(imageFile);
          if (imageUrl != null) {
            imageUrls.add(imageUrl);
          }
        }

        // Crie o documento do evento com o e-mail do usuário
        await FirebaseFirestore.instance.collection("event").add({
          "title": _titleController.text,
          "dateTime": _dateController.text,
          "location": locationName,
          "attendanceLimit": _attendanceLimitsController.text,
          "description": _descriptionController.text,
          "imageUrls": imageUrls,
          "userEmail":
              user.email, // Adicione o e-mail do usuário ao documento do evento
          "createdAt": DateTime.now(),
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(title: 'Home'),
          ),
        );
      } catch (e) {
        print('Erro ao criar o evento: $e');
        // Handle error (show a snackbar, dialog, etc.)
      }
    } else {
      // Handle case when user is not logged in
    }
  }

  Future<void> getLocationCoordinates(String locationName) async {
    try {
      List<Location> locations = await locationFromAddress(locationName);
      if (locations != null && locations.isNotEmpty) {
        Location location = locations[0];
        double latitude = location.latitude;
        double longitude = location.longitude;
        print('Latitude: $latitude, Longitude: $longitude');
      } else {
        print('Nenhuma coordenada encontrada para a localização fornecida.');
      }
    } catch (e) {
      print('Erro ao obter coordenadas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 191, 180),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Create Event",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                color: Color.fromARGB(255, 243, 190, 177),
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
                              width: 120,
                              height: 120,
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
                          const SizedBox(width: 20),
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
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Event Title',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 167, 166, 166)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          DateTime? dateTime = await showOmniDateTimePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1600)
                                .subtract(const Duration(days: 3652)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 3652)),
                          );
                          if (dateTime != null) {
                            String formattedDateTime =
                                DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
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
                                borderSide: BorderSide(color: Colors.black)),
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                          enabled: false,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 6000, // Defina a largura desejada
                        height: 65, // Defina a altura desejada
                        child: LocationAutocomplete(
                          locationName: locationName,
                          onChanged: (value) async {
                            setState(() {
                              locationName = value;
                            });
                            if (value.isNotEmpty) {
                              if (value.isNotEmpty) {
                                getLocationCoordinates(value);
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _attendanceLimitsController,
                        decoration: const InputDecoration(
                          hintText: 'Attendance limit',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 167, 166, 166)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          prefixIcon: Icon(Icons.person_add_rounded),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Events Description',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 167, 166, 166)),
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
                                  // Abra o seletor de imagem da galeria ou da câmera
                                  final pickedFile = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  // Se a seleção da galeria estiver vazia, tente abrir a câmera
                                  if (pickedFile == null) {
                                    final pickedCameraFile = await ImagePicker()
                                        .pickImage(source: ImageSource.camera);
                                    if (pickedCameraFile != null) {
                                      setState(() {
                                        _selectedImages.add(File(pickedCameraFile
                                            .path)); // Utilize pickedCameraFile.path para a câmera
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
                              SizedBox(width: 10),
                              Text(_selectedImages.length.toString()),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _createEvent();
                              await updateOrganizedEventsCount();
                            },
                            child: const Text("Create Event"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
