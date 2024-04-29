import 'package:app/screens/eventsearch.dart';
import 'package:flutter/material.dart';
import 'package:app/backend/Search_Bar/Search_Bar_Algo.dart';
import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/searchbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/eventsearch.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController search;
  final VoidCallback onTapMenu;
  final String currentScreen;

  CustomSearchBar(
      {Key? key,
      required this.search,
      required this.onTapMenu,
      required this.currentScreen})
      : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  EventHandler eventHandler = EventHandler();
  List<Map<String, dynamic>> suggestions = [];
  List<String> eventsID = [];

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

  Future<void> getEventsBySuggestions() async {
    eventsID.clear();

    List suggestionTitles =
        suggestions.map((suggestion) => suggestion['title']).toList();

    await FirebaseFirestore.instance
        .collection('event')
        .where('title', whereIn: suggestionTitles)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        print(element.reference);
        eventsID.add(element.reference.id);
      });
    });
  }

  void _onSearchTextChanged() async {
    if (widget.currentScreen != 'EventSearch') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventSearch()),
      );
    }

    String input = widget.search.text;
    if (input.isNotEmpty) {
      // Call your search algorithm to get autocomplete suggestions
      suggestions = await eventHandler.calculateRecommendations(input);
    } else {
      suggestions.clear();
    }
    setState(() {}); // Update the UI to reflect the changes
  }

  void _SwitchScreens() {}

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
                suffixIcon: GestureDetector(
                  onTap: widget.onTapMenu,
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
              onChanged: (value) => _onSearchTextChanged(),
            ),
          ),
          if (suggestions.isNotEmpty)
            FutureBuilder(
              future: getEventsBySuggestions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (eventsID.isNotEmpty) {
                  return Expanded(
                    // Add Expanded here
                    child: ListView.builder(
                      itemCount: eventsID.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              // Action when tapping on the card
                              print('Clicked on event ${eventsID[index]}');
                            },
                            child: Card(
                              elevation: 4,
                              child: ListTile(
                                title: Text(eventsID[index]),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container(); // Return an empty container if no data is available
              },
            ),
        ],
      ),
    );
  }
}
