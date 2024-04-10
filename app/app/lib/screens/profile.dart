import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key, required this.title});
  final String title;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  File? _image;

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
                      ? const Icon(Icons.add_a_photo,
                          size: 40, color: Colors.white)
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
                  onPressed: () {},
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
              style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold ),
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
                      padding: EdgeInsets.only(right: 8.0), // Add padding only to the right
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
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
