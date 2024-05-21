import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/read%20data/firestore_chat.dart';

class ChatPage extends StatefulWidget {
  final String eventId;
  const ChatPage({required this.eventId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatFirestore chatFirestore = ChatFirestore();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 10),
                  FutureBuilder<Map<String, dynamic>>(
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
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('Event data not available'),
                        );
                      } else {
                        return Expanded(child: 
                        Text(
                          snapshot.data!['title'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ));
                      }
                    },
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      // Handle information icon action
                    },
                    icon: Icon(Icons.info),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey, // Line separating chat info and messages
            ),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: chatFirestore.getEventMessageStream(widget.eventId),
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
                    return Center(
                      child: Text('No messages yet.'),
                    );
                  } else {
                    final messages = snapshot.data!;
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isUserMessage = message['userId'] ==
                            FirebaseAuth.instance.currentUser!.email;
                        final tileColor = isUserMessage
                            ? const Color.fromARGB(255, 248, 255, 250)
                            : Colors.white;

                        return FutureBuilder<Map<String, dynamic>>(
                          future:
                              chatFirestore.getUserDataById(message['userId']),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (userSnapshot.hasError) {
                              return Center(
                                child: Text('Error: ${userSnapshot.error}'),
                              );
                            } else if (!userSnapshot.hasData ||
                                userSnapshot.data!.isEmpty) {
                              return Align(
                                alignment: isUserMessage
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: 0.5,
                                  child: Card(
                                    elevation: 4,
                                    color: tileColor,
                                    child: ListTile(
                                      title: Text('Unknown User'),
                                      subtitle: Text(message['message'] ?? ''),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              final userData = userSnapshot.data!;
                              final username = isUserMessage
                                  ? 'Eu'
                                  : (userData['username'] ?? 'Unknown');
                              final profilePicture =
                                  userData['profilepicture'] ?? '';

                              return Align(
                                alignment: isUserMessage
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: 0.5,
                                  child: Card(
                                    elevation: 4,
                                    color: tileColor,
                                    child: ListTile(
                                      leading: profilePicture.isNotEmpty
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(profilePicture),
                                            )
                                          : null,
                                      title: Text(username),
                                      subtitle: Text(message['message'] ?? ''),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
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
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
