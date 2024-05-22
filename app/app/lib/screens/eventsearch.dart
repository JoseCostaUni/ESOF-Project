import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/searchbar.dart';
import 'package:app/screens/event_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/backend/Search_Bar/Search_Bar_Algo.dart';
import 'package:app/screens/searched_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  String _orderBy = 'createdAt';
  bool _descending = true;

  // ignore: unused_element
  Future<List<Map<String, dynamic>>> _loadEvents(String query) async {
    return Future.delayed(const Duration(seconds: 2), () {
      return List.generate(10, (index) => {'title': 'Event $index'});
    });
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    List<String> blockedUsers = List<String>.from(userData['blocked'] ?? []);

    // Filter out events created by blocked users
    List<Map<String, dynamic>> filteredEvents = events.where((event) {
      return !blockedUsers.contains(event['userEmail']);
    }).toList();

    return filteredEvents;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    // Fetch the list of blocked users
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    List<String> blockedUsers = List<String>.from(userData['blocked'] ?? []);

    // Filter out blocked users
    List<Map<String, dynamic>> filteredUsers = users.where((user) {
      return !blockedUsers.contains(user['email']);
    }).toList();

    return filteredUsers;
  }

  Future<List<Map<String, dynamic>>> getEvents1() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('event')
        .orderBy(_orderBy, descending: _descending)
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    calcReccomendations(selectedOption);
  }

  void calcReccomendations(String _selectedOption) async {
    if (selectedOption == 'Events') {
      String input = _searchcontroller.text;
      await eventHandler.calcEvents(input, _orderBy, _descending);
      suggestions = eventHandler.getEvents();
      events = suggestions
          .where((event) =>
              event["userEmail"] != FirebaseAuth.instance.currentUser?.email)
          .toList();
    } else {
      String input = _searchcontroller.text;
      await eventHandler.calcUsers(input);
      suggestions = eventHandler.getEvents();
      users = suggestions
          .where((user) =>
              user['email'] != FirebaseAuth.instance.currentUser?.email)
          .toList();
    }
    setState(() {});
  }

  void _setSortingAttributes(String orderBy, bool descending) {
    setState(() {
      _orderBy = orderBy;
      _descending = descending;
    });
    Navigator.pop(context);
  }

  void sortEvents({
    String? orderBy_,
    bool descending = true,
  }) async {
    if (orderBy_ == 'dateTime') {
      events.sort((a, b) {
        return a['dateTime'].compareTo(b['dateTime']);
      });
    } else {
      events.sort((a, b) {
        return a['createdAt'].compareTo(b['createdAt']);
      });
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
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                    search: _searchcontroller,
                    currentScreen: 'EventSearch',
                    onTapMenu: () => checkScreen(),
                    onChanged: () =>
                        {events.clear(), calcReccomendations(selectedOption)},
                    onOptionSelected: (value) {
                      selectedOption = value;
                      calcReccomendations(selectedOption);
                    },
                    onSearchTextChanged: (orderBy, descending) =>
                        _setSortingAttributes(orderBy, descending),
                  ),
                ),
              ],
            ),
            if (events.isEmpty && selectedOption == 'Events')
              const Center(child: Text('No events found')),
            if (events.isNotEmpty && selectedOption == 'Events')
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: Future.value(getEvents()),
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
                                color: const Color.fromARGB(255, 243, 190, 177),
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
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image:
                                                        NetworkImage(imageUrl),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            options: CarouselOptions(
                                              aspectRatio: 16 / 9,
                                            )),
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
                                                      const SizedBox(width: 10),
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
                                                          Text(event['title'] ??
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
                                                            onPressed: () {},
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
                                                    child:
                                                                          Container(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                0),
                                                                        constraints:
                                                                            BoxConstraints(maxWidth: double.infinity),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Row(
                                                                                children: [
                                                                                  IconButton(
                                                                                    onPressed: () {},
                                                                                    icon: const Icon(Icons.date_range_rounded),
                                                                                    iconSize: 20,
                                                                                  ),
                                                                                  Flexible(
                                                                                    child: Text(
                                                                                      event['dateTime'] ?? '',
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  IconButton(
                                                                                    onPressed: () {},
                                                                                    icon: const Icon(Icons.people),
                                                                                    iconSize: 20,
                                                                                  ),
                                                                                  Flexible(
                                                                                    child: Text(
                                                                                      '${event['eventosInscritos']?.length ?? 0}/${event['attendanceLimit']}',
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ))
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
            if (users.isEmpty && selectedOption == 'People')
              const Center(child: Text('No people found')),
            if (users.isNotEmpty && selectedOption == 'People')
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
