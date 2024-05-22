import 'package:app/features/bottomappnavigator.dart';
import 'package:app/features/maps_screen.dart';
import 'package:app/features/searchbar.dart';
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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, RestorationMixin {
  TabController? _tabController;
  final RestorableInt _tabIndex = RestorableInt(0);
  int _currentIndex = 0;
  String _orderBy = 'createdAt';
  bool _descending = true;
  final TextEditingController _searchcontroller = TextEditingController();

  @override
  String get restorationId => 'home_page';
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_tabIndex, 'tab_index');
    _tabController!.index = _tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _tabIndex.value = _tabController!.index;
      });
    });
    super.initState();
  }

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

  void sortEvents(String orderBy, bool descending) {
    setState(() {
      _orderBy = orderBy;
      _descending = descending;
    });
    Navigator.pop(context);
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
                  setState(() {
                    _orderBy = 'createdAt';
                    _descending = false;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Sort by Date Time'),
                onTap: () {
                  setState(() {
                    _orderBy = 'dateTime';
                    _descending = false;
                  });
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

    DateTime now = DateTime.now();
    return querySnapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        })
        .toList()
        .where((event) =>
            !blockedUsers.contains(event['userEmail']) &&
            DateTime.parse(event['dateTime']).isAfter(now))
        .toList();
  }

  Future<void> _LikeEvent(String eventId) async {
    print('Liking event $eventId');

    String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    if (userEmail == '') {
      return Future<void>.value();
    } else {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      print('User data: $userData');

      if (userData['likes'] == null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({'likes': []});
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({
          'likes': FieldValue.arrayUnion([eventId])
        });
      }
    }
    return Future<void>.value();
  }

  Future<void> _Dislike(String eventId) async {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    if (userEmail == '') {
      return Future<void>.value();
    } else {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      if (userData['likes'] == null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({'likes': []});
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({
          'likes': FieldValue.arrayRemove([eventId])
        });
      }
    }
    return Future<void>.value();
  }

  Future<bool> isLiked(String eventId) async {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    if (userEmail == '') {
      return false;
    } else {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      if (userData['likes'] == null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({'likes': []});
      }

      List<dynamic> likedEvents = List<dynamic>.from(userData['likes'] ?? []);

      return likedEvents.contains(eventId);
    }
  }

  Future<void> _refreshPage() async {
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> getLikedEvents() async {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    if (userEmail == '') {
      return [];
    } else {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      if (userData['likes'] == null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({'likes': []});
      }

      List<String> likedEventIds = List<String>.from(userData['likes'] ?? []);

      // Obtém apenas os eventos que foram marcados como "liked" pelo usuário
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('event')
          .where(FieldPath.documentId, whereIn: likedEventIds)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Tab(text: 'Events'),
      Tab(text: 'Liked Events'),
    ];
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
                      onTapMenu: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EventSearch()),
                        );
                      },
                      onChanged: () {},
                      currentScreen: '',
                      onSearchTextChanged: (orderBy, descending) => sortEvents(
                            orderBy,
                            descending,
                          )),
                ),
              ],
            ),
            TabBar(
              controller: _tabController,
              tabs: tabs,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshPage,
                child: TabBarView(controller: _tabController, children: [
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future:
                        getEvents(orderBy: _orderBy, descending: _descending),
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
                                                      .symmetric(horizontal: 2),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          imageUrl),
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
                                                        const SizedBox(
                                                            width: 10),
                                                        Expanded(
                                                          child: Text(userData[
                                                                  'username'] ??
                                                              ''),
                                                        ),
                                                        FutureBuilder<bool>(
                                                          future: isLiked(
                                                              event['id']),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return CircularProgressIndicator();
                                                            } else if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                  'Error: ${snapshot.error}');
                                                            } else {
                                                              bool liked = snapshot
                                                                      .data ??
                                                                  false; // Get the result from the future
                                                              return IconButton(
                                                                onPressed: () {
                                                                  if (liked) {
                                                                    _Dislike(event[
                                                                            'id'])
                                                                        .then(
                                                                            (_) {
                                                                      setState(
                                                                          () {}); // Update UI after disliking
                                                                    });
                                                                  } else {
                                                                    _LikeEvent(event[
                                                                            'id'])
                                                                        .then(
                                                                            (_) {
                                                                      setState(
                                                                          () {}); // Update UI after liking
                                                                    });
                                                                  }
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  color: liked
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        )
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
                  FutureBuilder(
                    future: getLikedEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('No liked events'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No liked events'),
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
                                                      .symmetric(horizontal: 2),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          imageUrl),
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
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(userData[
                                                                'username'] ??
                                                            ''),
                                                        FutureBuilder<bool>(
                                                          future: isLiked(
                                                              event['id']),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return CircularProgressIndicator();
                                                            } else if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                  'Error: ${snapshot.error}');
                                                            } else {
                                                              bool liked = snapshot
                                                                      .data ??
                                                                  false; // Get the result from the future
                                                              return IconButton(
                                                                onPressed: () {
                                                                  if (liked) {
                                                                    _Dislike(event[
                                                                            'id'])
                                                                        .then(
                                                                            (_) {
                                                                      setState(
                                                                          () {}); // Update UI after disliking
                                                                    });
                                                                  } else {
                                                                    _LikeEvent(event[
                                                                            'id'])
                                                                        .then(
                                                                            (_) {
                                                                      setState(
                                                                          () {}); // Update UI after liking
                                                                    });
                                                                  }
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  color: liked
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        )
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
                                                            const EdgeInsets
                                                                .only(top: 0),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 0),
                                                          constraints:
                                                              BoxConstraints(
                                                                  maxWidth: double
                                                                      .infinity),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {},
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .date_range_rounded),
                                                                      iconSize:
                                                                          20,
                                                                    ),
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        event['dateTime'] ??
                                                                            '',
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {},
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .people),
                                                                      iconSize:
                                                                          20,
                                                                    ),
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        '${event['eventosInscritos']?.length ?? 0}/${event['attendanceLimit']}',
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
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
                ]),
              ),
            )
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
