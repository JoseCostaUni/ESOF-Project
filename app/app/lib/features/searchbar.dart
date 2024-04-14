import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController search;
  final VoidCallback onTapMenu;
  const CustomSearchBar(
      {super.key, required this.search, required this.onTapMenu});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 202, 178, 172),
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 213, 177, 168),
        ),
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }
}
