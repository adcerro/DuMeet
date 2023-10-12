import 'package:flutter/material.dart';
import 'year.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Scaffold(body: SafeArea(child: Year())),
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
    );
  }
}
