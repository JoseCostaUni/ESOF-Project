import 'package:app/screens/editevent.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/features/bottomappnavigator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventPage extends StatefulWidget {
  final String eventId;

  EventPage({required this.eventId});

  @override
  State<EventPage> createState() => _EventPageState();
}

Future<String> getUserName(String userEmail) async {
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userEmail).get();
  Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
  return userData['username'] ?? 'Unknown user';
}

Future<String> getUserProfilePicture(String userEmail) async {
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userEmail).get();
  Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
  return userData['profilepicture'] ?? 'default_picture_url';
}

Future<int> getRegisteredEventsCount(String userEmail) async {
  final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userEmail).get();
  final userData = userDoc.data() as Map<String, dynamic>?;

  if (userData != null) {
    final List<dynamic>? eventosInscritos = userData['eventosInscritos'];
    return eventosInscritos?.length ?? 0;
  }

  return 0;
}

class _EventPageState extends State<EventPage> {
  int _currentIndex = 0;
  bool _isJoined = false;

  @override
  void initState() {
    super.initState();
    checkIfUserJoinedEvent();
  }

  Future<void> checkIfUserJoinedEvent() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();
      final List<dynamic>? eventosInscritos = userData['eventosInscritos'];
      setState(() {
        _isJoined = eventosInscritos?.contains(widget.eventId) ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference event = FirebaseFirestore.instance.collection('event');
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: event.doc(widget.eventId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic>? data =
                  snapshot.data?.data() as Map<String, dynamic>?;

              if (data != null) {
                String? title = data['title'];
                String? location = data['location'];
                String? description = data['description'];
                String? dateTime = data['dateTime'];
                String? attendanceLimit = data['attendanceLimit'];
                List<dynamic>? imageUrls = data['imageUrls'];
                String? userEmail = data['userEmail'];

                final currentUser = FirebaseAuth.instance.currentUser;
                final isCreator = currentUser?.email == userEmail;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        CarouselSlider(
                          items: (imageUrls as List<dynamic>?)
                              ?.map<Widget>((imageUrl) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(),
                        ),
                        Positioned(
                          top: 10.0,
                          left: 10.0,
                          child: IconButton(
                            iconSize: 30,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FutureBuilder<String>(
                                  future: userEmail != null
                                      ? getUserProfilePicture(userEmail)
                                      : null,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      if (snapshot.hasError)
                                        return const Icon(Icons.error);
                                      return CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            snapshot.data ??
                                                'default_picture_url'),
                                        radius: 30.0,
                                      );
                                    }
                                  },
                                ),
                                Column(
                                  children: <Widget>[
                                    const Text('created by'),
                                    FutureBuilder<String>(
                                      future: userEmail != null
                                          ? getUserName(userEmail)
                                          : null,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }
                                          return Text(
                                            '@${snapshot.data ?? 'Unknown user'}', // display do username
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final currentUser =
                                        FirebaseAuth.instance.currentUser;
                                    if (currentUser != null) {
                                      if (currentUser.email == userEmail) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditeventPage(),
                                          ),
                                        );
                                      } else {
                                        if (_isJoined) {
                                          leaveEvent(widget.eventId);
                                        } else {
                                          joinEvent(widget.eventId);
                                        }
                                      }
                                    }
                                  },
                                  child: Text(
                                    isCreator
                                        ? 'Edit Event'
                                        : _isJoined
                                            ? 'Leave Event'
                                            : 'Join Event',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              ' ${title ?? ''}',
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today, // calendar icon
                                  color: Colors.black,
                                  size: 20.0,
                                ),
                                const SizedBox(width: 5.0),
                                Text('${dateTime ?? ''}'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on, // location icon
                                  color: Colors.black,
                                  size: 20.0,
                                ),
                                const SizedBox(width: 5.0),
                                Text('${location ?? ''}'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.people,
                                  color: Colors.black,
                                  size: 20.0,
                                ),
                                const SizedBox(width: 5.0),
                                FutureBuilder<DocumentSnapshot>(
                                  future: event.doc(widget.eventId).get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasData) {
                                      final data = snapshot.data?.data()
                                          as Map<String, dynamic>?;

                                      if (data != null) {
                                        final inscritos =
                                            data['eventosInscritos'] ?? [];
                                        final attendanceLimit =
                                            data['attendanceLimit'];

                                        return Text(
                                          '${inscritos.length}/${attendanceLimit ?? 0}',
                                        );
                                      } else {
                                        return const Text('Data not found');
                                      }
                                    } else {
                                      return const Text('Data not found');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Text('Description:\n${description ?? ''}'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Text('Data not found');
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
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

  Future<void> joinEvent(String eventId) async {
    final user = FirebaseAuth.instance.currentUser;
    final eventRef =
        FirebaseFirestore.instance.collection('event').doc(eventId);

    if (user != null) {
      // Verifica se o evento existe
      final eventDoc = await eventRef.get();

      if (eventDoc.exists) {
        // Atualiza o evento para adicionar o usuário à lista de inscritos
        await eventRef.update({
          'eventosInscritos': FieldValue.arrayUnion([user.email]),
        });

        // Adiciona o evento à lista de eventos inscritos do usuário
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .update({
          'eventosInscritos': FieldValue.arrayUnion([eventId]),
        });

        // Atualiza o estado para refletir que o usuário se juntou ao evento
        setState(() {
          _isJoined = true;
        });
      } else {
        // Se o evento não existir, você pode optar por criar um novo evento aqui
        print('Evento não encontrado.');
      }
    }
  }

  Future<void> leaveEvent(String eventId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Remove o evento da lista de eventos inscritos do usuário
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .update({
        'eventosInscritos': FieldValue.arrayRemove([eventId]),
      });

      // Remove o usuário da lista de inscritos no evento
      await FirebaseFirestore.instance.collection('event').doc(eventId).update({
        'eventosInscritos': FieldValue.arrayRemove([user.email]),
      });

      setState(() {
        _isJoined = false;
      });
    }
  }
}
