import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 228, 225),
      appBar: AppBar(
        backgroundColor: Colors.transparent   ,
        title: const Text(
          'About',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'assets/buddy.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 30),
            const Text(
              'Version 1.0.2',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'HelpBuddies respects the intellectual property rights of others and expects its users to do the same. If you believe that your copyrighted work has been reproduced, adapted, distributed, or displayed within our app in a manner that constitutes copyright infringement, please submit a notification in accordance with the Digital Millennium Copyright Act (DMCA) by contacting us at helpbuddies@fakeemail.pt @ 2024-ES-LEIC04T4. All rights reserved. The app are registered trademarks of LEIC04T4 and may not be used by third parties without express written permission',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
