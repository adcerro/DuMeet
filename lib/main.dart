import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(today.month.toString()),
        ),
        body: CalendarDatePicker(
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
          onDateChanged: (date) {
            print(date);
          },
        ),
      ),
    );
  }
}
