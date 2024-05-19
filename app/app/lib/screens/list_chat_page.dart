import 'dart:async';

import 'package:app/screens/event_page.dart';
import 'package:app/screens/chat_page.dart';
import 'package:app/features/bottomappnavigator.dart';
import 'package:app/screens/homepage.dart';
import 'package:app/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/read%20data/firestore_chat.dart';

class ListChatPage extends StatefulWidget {
  const ListChatPage({Key? key});

  @override
  State<ListChatPage> createState() => _ListChatPageState();
}

class _ListChatPageState extends State<ListChatPage> {
  int _currentIndex = 2;
  final ChatFirestore chatFirestore = ChatFirestore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    'Group Chats',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: chatFirestore.getCurUserChatListSnapshot(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No group chats available.'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final event = snapshot.data![index];
                        final imageUrls = event['imageUrls'] ?? '';
                        final imageUrl =
                            imageUrls.isNotEmpty ? imageUrls[0] : '';

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ChatPage(eventId: event['id']),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: imageUrl.isNotEmpty
                                      ? NetworkImage(imageUrl)
                                      : AssetImage('assets/buddy.png')
                                          as ImageProvider,
                                ),
                                title: Text(event['title'] ?? 'No title'),
                                subtitle:
                                    Text(event['location'] ?? 'No location'),
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
