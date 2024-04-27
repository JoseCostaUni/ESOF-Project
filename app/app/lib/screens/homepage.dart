import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/searchbar.dart';
import 'package:app/screens/perfil_do_evento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  // Método para buscar os eventos
  Future<List<Map<String, dynamic>>> getEvents() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('event')
        .orderBy('createdAt', descending: true)
        .get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: Column(
        children: [
          CustomSearchBar(
            search: _searchcontroller,
            onTapMenu: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventSearch()),
              );
            },
            currentScreen: '',
            // Adicione ação ao menu aqui
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final event = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) =>  PerfilEvent()));
                          },
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(event['imageUrl'] ?? ''), // Exibição da foto
                              ),
                              title: Text(event['title'] ?? ''),
                              subtitle: Text(event['location'] ?? ''),
                            ),
                          ),
                        ),
                      );
                    },
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
