import 'dart:async';
import 'package:app/features/bottomappnavigator.dart';
import 'package:app/screens/editprofile.dart';
import 'package:app/screens/event_page.dart';
import 'package:app/screens/settingpages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key, required this.title, required this.username});
  final String title;
  final String username;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  int _currentIndex = 3;
  String? username;
  List<String> docid = [];
  User? currentuser = FirebaseAuth.instance.currentUser;
  String _image = "";
  String _selectedEventType = 'created';

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.email)
            .get();
        final String imageUrl = docSnapshot.get('profilepicture');
        if (imageUrl.isNotEmpty) {
          setState(() {
            _image = imageUrl;
          });
        }
      } catch (e) {
        print('Failed to load image from Firebase Storage: $e');
      }
    }
  }

  Future<String> getUsername() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(_currentuser!.email)
        .get();
    if (snapshot.exists) {
      return snapshot.data()?['username'] ?? '';
    } else {
      return '';
    }
  }

  Future<String> getUserDescription() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(_currentuser!.email)
        .get();
    if (snapshot.exists) {
      return snapshot.data()?['description'] ?? '';
    } else {
      return '';
    }
  }

  final User? _currentuser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getuserdetails() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentuser!.email)
        .get();
  }

  Future<List<Map<String, dynamic>>> getEvents(String type) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot;
    if (type == 'created') {
      querySnapshot = await FirebaseFirestore.instance
          .collection('event')
          .where('userEmail', isEqualTo: _currentuser!.email)
          .get();
    } else if (type == 'joined') {
      querySnapshot = await FirebaseFirestore.instance
          .collection('event')
          .where('eventosInscritos', arrayContains: _currentuser!.email)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('event')
          .where('participants', arrayContains: _currentuser!.email)
          .where('date', isLessThan: DateTime.now())
          .get();
    }

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  void refreshProfilePage() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              Navigator.pop(context);
            }
          },
          child: Stack(
            children: [
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: getuserdetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    Map<String, dynamic>? user = snapshot.data!.data();
                    if (user != null && user.containsKey('name')) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipOval(
                                    child: SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: _image.isNotEmpty
                                          ? Image.network(
                                              _image,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              color: const Color.fromARGB(
                                                  239, 255, 228, 225),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FutureBuilder<int>(
                                        future: getRegisteredEventsCount(
                                            _currentuser!.email!),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          if (snapshot.hasError) {
                                            return Text(
                                                "Error: ${snapshot.error}");
                                          }
                                          int registeredEventsCount =
                                              snapshot.data ?? 0;
                                          return Text(
                                            'Number of Joined Events: $registeredEventsCount',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      FutureBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                        future: getuserdetails(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return const SizedBox();
                                          }
                                          int organizedEventsCount =
                                              snapshot.data!.data()?[
                                                      'organizedEventsCount'] ??
                                                  0;
                                          return Text(
                                            'Number of Created Events: $organizedEventsCount',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              FutureBuilder<String>(
                                future: getUsername(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  }
                                  String username =
                                      snapshot.data ?? "No username";
                                  return Text(
                                    username,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              FutureBuilder<String>(
                                future: getUserDescription(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  }
                                  String description =
                                      snapshot.data ?? "No description";
                                  return Text(description);
                                },
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfile(), // Ensure this points to your edit profile screen
                                    ),
                                  );
                                },
                                child: const Text('Edit Profile'),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedEventType = 'created';
                                      });
                                    },
                                    child: Container(
                                      color: _selectedEventType == 'created'
                                          ? Colors.grey.shade200
                                          : null,
                                      padding: const EdgeInsets.all(8),
                                      child: const Row(
                                        children: [
                                          Text(
                                            'Created Events',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(Icons.event, size: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedEventType = 'joined';
                                      });
                                    },
                                    child: Container(
                                      color: _selectedEventType == 'joined'
                                          ? Colors.grey.shade200
                                          : null,
                                      padding: const EdgeInsets.all(8),
                                      child: const Row(
                                        children: [
                                          Text(
                                            'Joined Events',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(Icons.group, size: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedEventType = 'past';
                                      });
                                    },
                                    child: Container(
                                      color: _selectedEventType == 'past'
                                          ? Colors.grey.shade200
                                          : null,
                                      padding: const EdgeInsets.all(8),
                                      child: const Row(
                                        children: [
                                          Text(
                                            'Past Events',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(Icons.history, size: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 20, thickness: 1),
                              const SizedBox(height: 20),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 500,
                                child:
                                    FutureBuilder<List<Map<String, dynamic>>>(
                                  future: getEvents(_selectedEventType),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
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
                                              onTap: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => EventPage(
                                                        eventId: event['id'],
                                                        onEventUpdated:
                                                            refreshProfilePage),
                                                  ),
                                                );
                                                setState(() {});
                                              },
                                              child: Card(
                                                elevation: 4,
                                                color: const Color.fromARGB(
                                                    255, 243, 190, 177),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      width: double.infinity,
                                                      height: 200,
                                                      decoration:
                                                          const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  15.0),
                                                        ),
                                                      ),
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      child: CarouselSlider(
                                                          items: (event[
                                                                      'imageUrls']
                                                                  as List<
                                                                      dynamic>?)
                                                              ?.map<Widget>(
                                                                  (imageUrl) {
                                                            return Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                image:
                                                                    DecorationImage(
                                                                  image: NetworkImage(
                                                                      imageUrl),
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          options:
                                                              CarouselOptions()),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.0,
                                                          vertical: 10),
                                                      child: FutureBuilder<
                                                          DocumentSnapshot>(
                                                        future: FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(event[
                                                                'userEmail'])
                                                            .get(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const CircularProgressIndicator();
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                'Error: ${snapshot.error}');
                                                          } else {
                                                            Map<String,
                                                                    dynamic>?
                                                                userData =
                                                                snapshot.data
                                                                        ?.data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>?;

                                                            if (userData !=
                                                                null) {
                                                              return Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
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
                                                                            NetworkImage(userData['profilepicture'] ??
                                                                                ''),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              10),
                                                                      Text(userData[
                                                                              'username'] ??
                                                                          ''),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          2),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      top: 0,
                                                                    ),
                                                                    child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          IconButton(
                                                                            onPressed:
                                                                                () {},
                                                                            icon:
                                                                                const Icon(Icons.event_sharp),
                                                                            iconSize:
                                                                                20,
                                                                          ),
                                                                          Text(event['title'] ??
                                                                              ''),
                                                                        ]),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      top: 0,
                                                                    ),
                                                                    child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (_) => MapsScreen(locationNames: [
                                                                                            event['location'],
                                                                                          ])));
                                                                            },
                                                                            icon:
                                                                                const Icon(Icons.location_on),
                                                                            iconSize:
                                                                                20,
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Text(event['location']),
                                                                          )
                                                                        ]),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      top: 0,
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            IconButton(
                                                                              onPressed: () {},
                                                                              icon: const Icon(Icons.date_range_rounded),
                                                                              iconSize: 20,
                                                                            ),
                                                                            Text(event['dateTime'] ??
                                                                                ''),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            IconButton(
                                                                              onPressed: () {},
                                                                              icon: const Icon(Icons.people),
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
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Text("User data not found");
                    }
                  } else {
                    return const Text("No user data");
                  }
                },
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SettingsPage()));
                  },
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

class MapsScreen extends StatelessWidget {
  final List<String> locationNames;

  const MapsScreen({super.key, required this.locationNames});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: locationNames.map((locationName) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(locationName),
            );
          }).toList(),
        ),
      ),
    );
  }
}

Future<int> getRegisteredEventsCount(String userEmail) async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
      .instance
      .collection('event')
      .where('eventosInscritos', arrayContains: userEmail)
      .get();
  return querySnapshot.docs.length;
}
