import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/searchbar.dart';
import 'package:app/screens/createevent.dart';
import 'package:app/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/eventsearch.dart';
import 'package:flutter/material.dart';
import 'package:app/backend/Search_Bar/Search_Bar_Algo.dart';
import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/searchbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/eventsearch.dart';
import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/searchbar.dart';
import 'package:app/read%20data/Read_event.dart';
import 'package:app/screens/perfil_do_evento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/eventsearch.dart';

class EventSearch extends StatefulWidget {
  const EventSearch({Key? key}) : super(key: key);

  @override
  State<EventSearch> createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  EventHandler eventHandler = EventHandler();
  int _currentIndex = 0;
  String currentScreen = 'EventSearch';
  List<Map<String, dynamic>> suggestions = [];
  List<String> eventsID = [];
  List<Map<String, dynamic>> events = [];
  final TextEditingController _searchcontroller = TextEditingController();

  Future<List<Map<String, dynamic>>> _loadEvents(String query) async {
    return Future.delayed(Duration(seconds: 2), () {
      return List.generate(10, (index) => {'title': 'Event $index'});
    });
  }

  List<Map<String, dynamic>> getEvents() {
    return events;
  }

  void calcReccomendations() async {
    String input = _searchcontroller.text;
    await eventHandler.calcEvents(input);
    suggestions = await eventHandler.getEvents();
    events = [...suggestions];
    String a = "a";
    setState(() {});
  }

  void checkScreen() {
    if (currentScreen != 'EventSearch') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventSearch()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: Column(
        children: [
          CustomSearchBar(
            search: _searchcontroller,
            currentScreen: 'EventSearch',
            onTapMenu: () => checkScreen(),
            onChanged: () => {events.clear(), calcReccomendations()},
          ),
          if (events.isEmpty) Center(child: Text('No events found')),
          if (events.isNotEmpty)
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: Future.value(getEvents()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    final events = snapshot.data!;
                    return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PerfilEvent()),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      event['imageUrl'] ??
                                          ''), // Exibição da foto
                                ),
                                title: Text(event['title'] ?? ''),
                                subtitle: Text(event['location'] ?? ''),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text('No events found'),
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
