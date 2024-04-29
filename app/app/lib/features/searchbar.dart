import 'package:app/screens/eventsearch.dart';
import 'package:flutter/material.dart';
import 'package:app/backend/Search_Bar/Search_Bar_Algo.dart';
import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/searchbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/read%20data/Read_event.dart';
import 'package:app/screens/perfil_do_evento.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController search;
  final VoidCallback onTapMenu;
  final VoidCallback onChanged;
  final String currentScreen;
  Function(String)? onOptionSelected;

  CustomSearchBar(
      {Key? key,
      required this.search,
      required this.onTapMenu,
      required this.onChanged,
      required this.currentScreen,
      this.onOptionSelected})
      : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  EventHandler eventHandler = EventHandler();
  List<Map<String, dynamic>> suggestions = [];
  List<String> eventsID = [];
  List<Map<String, dynamic>> events = [];
  String? selectedOption = "";

  @override
  void initState() {
    super.initState();
    widget.search.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    widget.search.removeListener(_onSearchTextChanged);
    super.dispose();
  }

  List<Map<String, dynamic>> getEvents() {
    return events;
  }

  void _onSearchTextChanged() async {
    if (widget.currentScreen != 'EventSearch') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventSearch()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10, left: 20.0, right: 20.0, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventSearch()),
              );
            },
            child: TextField(
              controller: widget.search,
              decoration: InputDecoration(
                hintText: 'Search Event',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                suffixIcon: PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 'People',
                        child: Text('People'),
                      ),
                      const PopupMenuItem(
                        value: 'Events',
                        child: Text('Events'),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                    if (widget.onOptionSelected != null) {
                      widget.onOptionSelected!(selectedOption!);
                    }
                  },
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
              onChanged: (value) => widget.onChanged(),
            ),
          ),
        ],
      ),
    );
  }
}
