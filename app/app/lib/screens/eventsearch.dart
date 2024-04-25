import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/searchbar.dart';
import 'package:app/screens/createevent.dart';
import 'package:app/screens/profile.dart';
import 'package:flutter/material.dart';

class EventSearch extends StatefulWidget {
  const EventSearch({super.key});

  @override
  State<EventSearch> createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  int _currentIndex = 0;
  final TextEditingController _searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: Column(
        children: [
          CustomSearchBar(
            search: _searchcontroller,
            onTapMenu: () {},
            currentScreen: 'EventSearch',
            // Adicione ação ao menu aqui
          ),
        ],
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
