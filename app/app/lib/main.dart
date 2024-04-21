// ignore_for_file: unused_import

import 'package:app/screens/homepage.dart';
import 'package:app/screens/login.dart';
import 'package:app/screens/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
          )
        ],
        debug: true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'final app',
      home: LoginPage(),
    );
  }
}
