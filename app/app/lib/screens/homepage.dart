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
  List<Map<String, dynamic>> _sortedEvents =
      []; // Defina esta variável na sua classe HomePage

  Future<String> getUserName(String userEmail) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return userData['username'] ?? 'Unknown user';
  }

  Future<String> getUserProfilePicture(String userEmail) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return userData['profilepicture'] ?? 'default_picture_url';
  }

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
                                  child: FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(event['userEmail'])
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        Map<String, dynamic>? userData =
                                            snapshot.data?.data()
                                                as Map<String, dynamic>?;

                                        if (userData != null) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    backgroundColor: Colors
                                                        .grey, // You can set a default color here
                                                    backgroundImage:
                                                        NetworkImage(userData[
                                                                'profilepicture'] ??
                                                            ''),
                                                  ),
                                                  const SizedBox(
                                                      width:
                                                          10), // Espaçamento entre o avatar e o nome de usuário
                                                  Text(userData['username'] ??
                                                      ''),
                                                ],
                                              ),
                                              const SizedBox(
                                                  height:
                                                      10), // Espaçamento entre o nome de usuário e os detalhes do evento
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                            Icons.event_sharp),
                                                        iconSize: 20,
                                                      ),
                                                      Text(
                                                          event['title'] ?? ''),
                                                    ]),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                            Icons.location_on),
                                                        iconSize: 20,
                                                      ),
                                                      Text(event['location'])
                                                    ]),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween, // Ajuste o alinhamento conforme necessário
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(Icons
                                                              .date_range_rounded),
                                                          iconSize: 20,
                                                        ),
                                                        Text(
                                                            event['dateTime'] ??
                                                                ''),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                              Icons.people),
                                                          iconSize: 20,
                                                        ),
                                                        Text(
                                                          '${event['numeroPessoasInscritas']}/${event['attendanceLimit']}',
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Text('User data not found');
                                        }
                                      }
                                    },
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
                      onPressed: () async {
                        // Obtém a lista de eventos ordenados por data de forma decrescente
                        List<Map<String, dynamic>> sortedEvents =
                            await getEvents(
                                orderBy: 'dateTime', descending: true);

                        setState(() {
                          _sortedEvents = sortedEvents;
                        });
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
