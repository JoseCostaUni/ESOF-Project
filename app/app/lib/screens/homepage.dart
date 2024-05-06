import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/searchbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  int _currentIndex = 0;
  final TextEditingController _searchcontroller = TextEditingController();

  // Método para buscar os eventos
  Future<List<Map<String, dynamic>>> getEvents({
    String? orderBy,
    bool descending = true,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('event')
        .orderBy(orderBy ?? 'createdAt', descending: true)
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
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
            onChanged: () {},
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        EventPage(eventId: event['id'])));
                          },
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Container(
                                    child: CarouselSlider(
                                        items: (event['imageUrls']
                                                as List<dynamic>?)
                                            ?.map<Widget>((imageUrl) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: NetworkImage(imageUrl),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        options: CarouselOptions()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                            Text(event['title'] ?? ''),
                                            Text(event['location'] ?? ''),
                                            Text(event['dateTime'] ?? ''),
                                        ])
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                              //child: ListTile(
                              //leading: CircleAvatar(
                              //backgroundImage: NetworkImage(
                              //  event['imageUrl'] ??
                              //    ''), // Exibição da foto
                              //),
                              //title: Text(event['title'] ?? ''),
                              //subtitle: Text(event['location'] ?? ''),
                              //),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        getEvents(
                            orderBy: 'dateTime',
                            descending: true); // Passa o parâmetro descending
                        Navigator.pop(context);
                      },
                      child: Text('Por Data'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        getEvents(orderBy: 'Location');
                        Navigator.pop(context);
                      },
                      child: Text('Por Perímetro'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.sort),
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
