import 'package:flutter/material.dart';

class BlockedPage extends StatefulWidget {
  const BlockedPage({super.key});

  @override
  State<BlockedPage> createState() => _BlockedPageState();
}

class _BlockedPageState extends State<BlockedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 241, 238),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    iconSize: 50,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 220.0),
                      child: IconButton(
                        iconSize: 50.0,
                        icon: Icon(Icons.add_outlined),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
