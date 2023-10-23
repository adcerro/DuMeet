import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar/pages/login.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //The SafeArea Widget prevents the app from overlapping with OS stuff
      //in phones it avoids using the space of the notification bar
      home: Scaffold(body: SafeArea(child: Login())),
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
    );
  }
}
