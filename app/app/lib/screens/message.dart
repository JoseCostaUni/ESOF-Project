import 'package:app/features/bottomappnavigator.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  int _currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 241, 238),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            children: [
              IconButton(
                iconSize: 30,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ],
          ),
        ]),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              (() {
                _currentIndex = index;
              });
            });
          }),
    );
  }
}
