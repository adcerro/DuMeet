import 'package:calendar/month.dart';
import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('S'),
            Text('M'),
            Text('T'),
            Text('W'),
            Text('T'),
            Text('F'),
            Text('S'),
          ],
        ),
        InfiniteListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Month(
              num: DateTime.now().month + index,
            );
          },
        )
      ],
    );
  }
}
