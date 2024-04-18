import 'package:flutter_driver/driver_extension.dart';
import '../lib/main.dart';
import 'package:flutter/material.dart';

void main() async {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}
