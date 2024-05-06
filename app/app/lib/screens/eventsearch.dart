import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/searchbar.dart';
import 'package:app/screens/event_page.dart';
import 'package:flutter/material.dart';
import 'package:app/backend/Search_Bar/Search_Bar_Algo.dart';
import 'package:app/screens/searched_profile.dart';

class EventSearch extends StatefulWidget {
  // ignore: use_super_parameters
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
  List<Map<String, dynamic>> users = [];
  final TextEditingController _searchcontroller = TextEditingController();
  String selectedOption = "Events";

  // ignore: unused_element
  Future<List<Map<String, dynamic>>> _loadEvents(String query) async {
    return Future.delayed(const Duration(seconds: 2), () {
      return List.generate(10, (index) => {'title': 'Event $index'});
    });
  }

  List<Map<String, dynamic>> getEvents() {
    return events;
  }

  List<Map<String, dynamic>> getUsers() {
    return users;
  }

  // ignore: no_leading_underscores_for_local_identifiers
  void calcReccomendations(String _selectedOption) async {
    if (selectedOption == 'Events') {
      users.clear();
      String input = _searchcontroller.text;
      await eventHandler.calcEvents(input);
      suggestions = eventHandler.getEvents();
      events = [...suggestions];
      // ignore: unused_local_variable
      String a = "a";
      setState(() {});
    } else {
      events.clear();
      String input = _searchcontroller.text;
      await eventHandler.calcUsers(input);
      suggestions = eventHandler.getEvents();
      users = [...suggestions];
      // ignore: unused_local_variable
      String a = "a";
      setState(() {});
    }
  }

  void checkScreen() {
    if (currentScreen != 'EventSearch') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EventSearch()),
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
            onChanged: () =>
                {events.clear(), calcReccomendations(selectedOption)},
            onOptionSelected: (value) {
              selectedOption = value;
              calcReccomendations(selectedOption);
            },
          ),
          if (events.isEmpty && selectedOption == 'Events')
            const Center(child: Text('No events found')),
          if (events.isNotEmpty)
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: Future.value(getEvents()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
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
                                    builder: (_) => EventPage(eventId: event['id'])),
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
                    return const Center(
                      child: Text('No events found'),
                    );
                  }
                },
              ),
            ),
          if (users.isEmpty && selectedOption == 'People')
            const Center(child: Text('No people found')),
          if (users.isNotEmpty)
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: Future.value(getUsers()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    final users = snapshot.data!;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        SearchedProfile(user: user)),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      user['profilepicture'] ??
                                          ''), // Exibição da foto
                                ),
                                title: Text(user['name'] ?? ''),
                                subtitle: Text(user['username'] ?? ''),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No events found'),
                    );
                  }
                },
              ),
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
