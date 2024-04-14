import 'dart:io';

import 'package:app/features/bottomappnavigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  int _currentIndex = 1;
 final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _attendanceLimitsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? __image;
  void PostEvent() {}
  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');

    if (imagePath != null) {
      setState(() {
        __image = File(imagePath);
      });
    }
  }

  
   Future<void> _createEvent() async {
    if (_titleController.text.isEmpty ||
      _dateController.text.isEmpty ||
      _locationController.text.isEmpty ||
      _attendanceLimitsController.text.isEmpty ||
      _descriptionController.text.isEmpty) {
        return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection("event").add({
          "title": _titleController.text,
          "dateTime": _dateController.text,
          "location": _locationController.text,
          "attendanceLimit": _attendanceLimitsController.text,
          "description": _descriptionController.text,
        });
        Navigator.pop(context);
      } catch (e) {
        print('Error creating event: $e');
        // Handle error (show a snackbar, dialog, etc.)
      }
    } else {
      // Handle case when user is not logged in
    }
  }

  Future<void> _cropImage() async {
    if (__image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: __image!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Resize your image',
            toolbarColor: const Color.fromARGB(255, 202, 178, 172),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          __image = File(croppedFile.path);
        });
      }
    }
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        __image = File(pickedFile.path);
      });
      await _cropImage();
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      __image = null;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image');
  }

  Future<void> _saveImage() async {
    if (__image != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', __image!.path);
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 241, 238),
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
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: __image != null
                              ? Image.file(
                                  __image!,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey[200],
                                ),
                        ),
                      ),
                      InkWell(
                        onTap: _removeImage,
                        child: const Text(
                          "Remove",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.photo),
                            onPressed: () => getImage(ImageSource.gallery),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () => getImage(ImageSource.camera),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Event Title',
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _dateController,
                        decoration: const InputDecoration(
                          hintText: 'Date and time',
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          hintText: 'Location',
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _attendanceLimitsController,
                        decoration: const InputDecoration(
                          hintText: 'Attendance limit',
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Events Description',
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: _createEvent,
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