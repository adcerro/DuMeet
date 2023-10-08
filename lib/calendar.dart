import 'package:calendar/month.dart';
import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return InfiniteListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Month(
          num: (DateTime.now().month - 1 + index) % 12 + 1,
        );
      },
    );
  }
}
