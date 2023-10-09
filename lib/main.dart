import 'package:flutter/material.dart';
import 'calendar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Calendar(),
      ),
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
    );
  }
}
