import 'dart:async';

import 'package:app/screens/event_page.dart';
import 'package:app/features/bottomappnavigator.dart';
import 'package:app/screens/homepage.dart';
import 'package:app/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app/read data/firestore_chat.dart';

class ChatPage extends StatefulWidget {
  final String eventId;
  const ChatPage({required this.eventId});

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  int _currentIndex = 2;
  final ChatFirestore chatFirestore = ChatFirestore();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0, right: 180.0),
            child: FutureBuilder<Map<String, dynamic>>(
              future: chatFirestore.getEventDataById(widget.eventId),
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
                  return Text(
                    snapshot.data!['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: chatFirestore.getEventMessageData(widget.eventId),
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
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final message = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: FutureBuilder<Map<String, dynamic>>(
                              future: chatFirestore
                                  .getUserDataById(message['userId']),
                              builder: (context, sender) {
                                if (sender.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (sender.hasError) {
                                  return Center(
                                    child: Text('Error: ${sender.error}'),
                                  );
                                } else {
                                  Color tileColor_ = message['userId'] ==
                                          FirebaseAuth
                                              .instance.currentUser!.email
                                      ? Color.fromARGB(255, 248, 255, 250)!
                                      : Colors.white;
                                  String username_ = message['userId'] ==
                                          FirebaseAuth
                                              .instance.currentUser!.email
                                      ? "Eu"
                                      : sender.data!['username'];

                                  Alignment alignment_ = message['userId'] ==
                                          FirebaseAuth
                                              .instance.currentUser!.email
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft;
                                  return Container(
                                    alignment: alignment_,
                                    child: Card(
                                      elevation: 4,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            sender.data!['profilepicture'] ??
                                                '',
                                          ),
                                        ),
                                        title: Text(username_),
                                        subtitle:
                                            Text(message['message'] ?? ''),
                                        tileColor: tileColor_,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  final message = _textEditingController.text.trim();
                  if (message.isNotEmpty) {
                    chatFirestore.storeMessage(message, widget.eventId);
                    _textEditingController.clear();
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
