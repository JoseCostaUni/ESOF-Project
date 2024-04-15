import 'package:app/screens/eventsearch.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController search;
  final VoidCallback onTapMenu;
  const CustomSearchBar({Key? key, required this.search, required this.onTapMenu}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20.0, right: 20.0, bottom: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventSearch()), 
          );
        },
        child: TextField(
          controller: search,
          decoration: InputDecoration(
            hintText: 'Search Event',
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            suffixIcon: GestureDetector(
              onTap: onTapMenu,
              child: const Icon(Icons.menu),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 202, 178, 172),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 202, 178, 172),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 213, 177, 168),
          ),
          style: const TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}
