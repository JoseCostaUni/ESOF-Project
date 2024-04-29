import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/searchbar.dart';
import 'package:app/read%20data/firestore_read_changes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/eventsearch.dart';
import 'package:app/screens/event_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> eventsID = [];
  int _currentIndex = 0;
  final TextEditingController _searchcontroller = TextEditingController();
  Map<String, dynamic>? _createdEvent;

  Future<void> getEventsId() async {
    eventsID.clear();
    await FirebaseFirestore.instance
        .collection('event')
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              print(element.reference);
              eventsID.add(element.reference.id);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: Column(
        children: [
          CustomSearchBar(
            search: _searchcontroller,
            onTapMenu: () {},
            // Adicione ação ao menu aqui
          ),
          Expanded(
            child: FutureBuilder(
              future: getEventsId(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: eventsID.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // Ação ao clicar no cartão
                          print('Clicou no evento ${eventsID[index]}');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventPage(
                                eventId: eventsID[index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          child: ListTile(
                            title: GetEvents(documentId: eventsID[index]),
                          ),
                        ),
                      ),
                    );
                  },
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
