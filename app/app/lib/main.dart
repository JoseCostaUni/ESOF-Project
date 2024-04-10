// ignore_for_file: unused_import

import 'package:app/screens/homepage.dart';
import 'package:app/screens/profile.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'final app',
      home: HomePage(title: 'Home Page'),
    );
  }
}

