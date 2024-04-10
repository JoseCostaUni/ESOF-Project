import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(239, 255, 228, 225),
      body: const Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Event',
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white
              ),
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffa32d10), 
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'add',
          ),
        ],
      ),
    );
  }
}
