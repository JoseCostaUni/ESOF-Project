import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/maps_screen.dart';
import 'package:app/features/searchbar.dart';
import 'package:app/screens/list_chat_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/eventsearch.dart';
import 'package:app/screens/event_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final TextEditingController _searchcontroller = TextEditingController();

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

  void refresh() {
    setState(() {});
  }

  void _showSortOptionsSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Sort by Created At'),
                onTap: () {
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Sort by Date Time'),
                onTap: () {
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> getEvents({
    String? orderBy,
    bool descending = true,
  }) async {
    // gets the list of blocked users
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    List<String> blockedUsers = List<String>.from(userData['blocked'] ?? []);

    QuerySnapshot querySnapshot;
    if (orderBy == 'dateTime') {
      querySnapshot = await FirebaseFirestore.instance
          .collection('event')
          .orderBy('dateTime', descending: descending)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('event')
          .orderBy('createdAt', descending: false)
          .get();
    }

    return querySnapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        })
        .toList()
        .where((event) => !blockedUsers.contains(event['userEmail']))
        .toList();
  }

  Future<void> _refreshPage() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListChatPage(),
                ),
              );
            }
          },
          onHorizontalDragStart: (details) {},
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _showSortOptionsSheet,
                    icon: const Icon(Icons.sort),
                  ),
                  Expanded(
                    child: CustomSearchBar(
                      search: _searchcontroller,
                      onTapMenu: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EventSearch()),
                        );
                      },
                      onChanged: () {},
                      currentScreen: '',
                    ),
                  ),
                ],
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshPage,
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
                                          builder: (_) => EventPage(
                                              eventId: event['id'],
                                              onEventUpdated: refresh)));
                                },
                                child: Card(
                                  elevation: 4,
                                  color:
                                      const Color.fromARGB(255, 243, 190, 177),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          imageUrl),
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
                                              return const CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
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
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              Colors.grey,
                                                          backgroundImage:
                                                              NetworkImage(userData[
                                                                      'profilepicture'] ??
                                                                  ''),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(userData[
                                                                'username'] ??
                                                            ''),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            IconButton(
                                                              onPressed: () {},
                                                              icon: const Icon(Icons
                                                                  .event_sharp),
                                                              iconSize: 20,
                                                            ),
                                                            Text(event[
                                                                    'title'] ??
                                                                ''),
                                                          ]),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            IconButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (_) =>
                                                                            MapsScreen(
                                                                              locationNames: [
                                                                                event['location']
                                                                              ],
                                                                            )));
                                                              },
                                                              icon: const Icon(Icons
                                                                  .location_on),
                                                              iconSize: 20,
                                                            ),
                                                            Expanded(
                                                                child: Text(event[
                                                                    'location']))
                                                          ]),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon: const Icon(
                                                                    Icons
                                                                        .date_range_rounded),
                                                                iconSize: 20,
                                                              ),
                                                              Text(event[
                                                                      'dateTime'] ??
                                                                  ''),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon: const Icon(
                                                                    Icons
                                                                        .people),
                                                                iconSize: 20,
                                                              ),
                                                              Text(
                                                                '${event['eventosInscritos']?.length ?? 0}/${event['attendanceLimit']}',
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return const Text(
                                                    'User data not found');
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ],
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
              ),
            ],
          ),
        ),
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
