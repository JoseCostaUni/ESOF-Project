import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/eventsearch.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final TextEditingController _searchcontroller = TextEditingController();
  Map<String, dynamic>? _createdEvent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? eventData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (eventData != null) {
      setState(() {
        _createdEvent = eventData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exibindo detalhes do evento
          if (_createdEvent != null) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Event Title: ${_createdEvent!['title']}'),
                  Text('Date and Time: ${_createdEvent!['dateTime']}'),
                  Text('Location: ${_createdEvent!['location']}'),
                ],
              ),
            ),
          ],
          Expanded(
            child: CustomSearchBar(
              search: _searchcontroller,
              onTapMenu: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EventSearch()),
                );
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
