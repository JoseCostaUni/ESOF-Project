import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();

}

class _MyProfilePageState extends State<MyProfilePage> {
  File? _image;

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: getImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                    ? const Icon(Icons.add_a_photo, size: 40, color: Colors.white)
                    : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              '@guebuzathegoat', // Fazer a ligação à base de dados
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'This is my alter-ego guebuza the goat for the win aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', // Fazer a ligação à base de dados
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 145 ,left: 10),
                child: Text(
                  '12', // Fazer a ligação à base de dados
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20 ,left: 30),
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
                padding: EdgeInsets.only(right: 70 ,left: 10),
                child: Text(
                  'Participations', // Fazer a ligação à base de dados
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 30 ,left: 30),
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
                padding: const EdgeInsets.only(right: 50,left: 10),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Edit Profile'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10 ,left: 10),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Share Profile'),
                ),
              ),
            ],
          )

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffa32d10),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
