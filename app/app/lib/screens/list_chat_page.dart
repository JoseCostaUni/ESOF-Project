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

class ListChatPage extends StatefulWidget {
  const ListChatPage({Key? key});

  @override
  State<ListChatPage> createState() => _ListChatPage();
}

class _ListChatPage extends State<ListChatPage> {
  int _currentIndex = 2;
  final ChatFirestore chatFirestore = ChatFirestore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 60.0, right: 180.0),
            child: Text(
              'Group Chats',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    event['imageUrl'] ??
                                        ''), // Exibição da foto
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
