import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
      ],
    );
  }
}
