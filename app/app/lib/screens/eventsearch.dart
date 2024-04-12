import 'package:app/screens/createevent.dart';
import 'package:app/screens/profile.dart';
import 'package:flutter/material.dart';

class EventSearch extends StatefulWidget {
  const EventSearch({super.key});

  @override
  State<EventSearch> createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Event',
                hintStyle: const TextStyle(color: Colors.black),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 202, 178, 172)),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 202, 178, 172)),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 213, 177, 168),
              ),
              style: const TextStyle(color: Colors.blue),
              //elevation: 2,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20), // Definindo o raio de borda
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
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const CreateEvent()));
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
                      MaterialPageRoute(
                        builder: (_) => const MyProfilePage(title: "profile", username: '',)));

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
