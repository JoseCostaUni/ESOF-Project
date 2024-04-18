// ignore_for_file: unused_import

import 'package:app/screens/homepage.dart';
import 'package:app/screens/login.dart';
import 'package:app/screens/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
