import 'package:flutter/material.dart';
import 'calendar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  String monthName(int num) {
    switch (num) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'January';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(monthName(today.month)),
        ),
        body: Calendar(),
      ),
    );
  }
}
