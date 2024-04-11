import 'dart:io';

import 'package:app/screens/homepage.dart';
import 'package:app/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;
  bool selected = false;

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomePage(title: "home"),
                        ),
                      );
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
                      GestureDetector(
                        onTap: getImage,
                        child: CircleAvatar(radius: 60, backgroundImage: _image != null ? FileImage(_image!) : null, child: _image == null ? const Icon(Icons.add_a_photo,size: 40,color: Colors.white70,) : null),
                      ),
                      const SizedBox(height: 20),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'Change Username',
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'Change Name',
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const TextField(
                        maxLines: null,
                        maxLength: 100,
                        decoration: InputDecoration(
                          hintText: 'New Description',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () {
                              Navigator.pop(context); 
                            },
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Adicione aqui a lógica para editar o perfil
                            },
                            child: const Text("Edit"),
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
                      MaterialPageRoute(builder: (_) => const HomePage(title: "Home")),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Colors.white,
                  onPressed: () {
                    // Adicione aqui a lógica para criar um evento
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  color: Colors.white,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyProfilePage(title: "profile")),
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
