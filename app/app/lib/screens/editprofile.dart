import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'profile.dart';
import 'package:app/screens/homepage.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;
  String _tempImageUrl = "";
  String _imageUrl = "";
  bool resized = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _loadText();
    _loadImage();
    super.initState();
  }

  Future<void> updateUserDetails(User? userCredential) async {
    if (userCredential != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.email)
          .update({
        'username': _usernameController.text,
        'name': _nameController.text,
        'description': _descriptionController.text,
        'profilepicture': _tempImageUrl
      });
    }
  }

  Future<void> _loadText() async{
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.email)
            .get();


        setState(() {
          final TextEditingController _nameController2 = TextEditingController(text: docSnapshot.get('name'));
          final TextEditingController _usernameController2 = TextEditingController(text: docSnapshot.get('username'));
          final TextEditingController _descriptionController2 = TextEditingController(text: docSnapshot.get('description'));
            
          _nameController = _nameController2;
          _usernameController = _usernameController2;
          _descriptionController = _descriptionController2;
        });
        
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
            _tempImageUrl = imageUrl;
          });
        }
      } catch (e) {
        print('Failed to load image from Firebase Storage: $e');
      }
    }
  }

  Future<void> _cropImage() async {
    if (_image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
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
              lockAspectRatio: false),
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
          _image = File(croppedFile.path!);
          resized = true;
        });
      }
    }
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _cropImage();
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      _imageUrl = _tempImageUrl;
      _tempImageUrl = "";
      resized = false;
      _image = null;
    });
  }

  Future<void> _saveImage() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userEmail = user.email!;

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref();
        final userImageRef = ref.child("user_profile").child('$userEmail.jpg');

        if (_image != null) {
          await userImageRef.putFile(_image!);

          _tempImageUrl = await userImageRef.getDownloadURL();

          await FirebaseFirestore.instance
              .collection("users")
              .doc(userEmail)
              .update({'profilepicture': _tempImageUrl});

        } else {
          print('Image is null.');
        }
      } else {
        print('No user signed in.');
      }
    } catch (e) {
      print('Failed to upload image to Firebase Storage: $e');
    }
  }

  Future<void> _changeImageAfterSave() async {
    final user = FirebaseAuth.instance.currentUser;
    if (_tempImageUrl == "") {
      try {
        if (user != null) {
          final ref =
              firebase_storage.FirebaseStorage.instance.refFromURL(_imageUrl);
          await ref.delete();
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.email)
              .update({'profilepicture': ""});
        }
      } catch (e) {
        print('Failed to upload image to Firebase Storage: $e');
      }
    } else {
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.email)
            .update({'profilepicture': _tempImageUrl});
      }
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
                    "Edit Profile",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              ClipOval(
                                  child: SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Container(
                                        color: Colors.grey[200],
                                        child: !resized
                                            ? (_tempImageUrl == ""
                                                ? Container(color: Colors.grey[200]) 
                                                : Image.network(
                                                    _tempImageUrl,
                                                    fit: BoxFit.cover,
                                                  ))
                                            : Image.file(
                                                _image!,
                                                fit: BoxFit.cover,
                                              ),
                                      ))),
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
                                    onPressed: () =>
                                        getImage(ImageSource.gallery),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    icon: const Icon(Icons.camera_alt),
                                    onPressed: () =>
                                        getImage(ImageSource.camera),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          hintText: 'Change Username',
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Change Name',
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _descriptionController,
                        maxLines: null,
                        maxLength: 100,
                        decoration: const InputDecoration(
                          hintText: 'New Description',
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              updateUserDetails(
                                  FirebaseAuth.instance.currentUser);
                              _saveImage();
                              _changeImageAfterSave();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MyProfilePage(
                                    title: "Profile",
                                    username: '',
                                  ),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Updated user details'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Text("Save"),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomAppBar(
            color: const Color.fromARGB(255, 202, 178, 172),
            shape: const CircularNotchedRectangle(),
            shadowColor: Colors.black54,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.home),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HomePage(title: "Home")),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Colors.white,
                  onPressed: () {
                    // Add logic to create an event
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.message),
                  color: Colors.white,
                  onPressed: () {
                    // Add logic for messages
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MyProfilePage(
                                title: "Profile",
                                username: '',
                              )),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
