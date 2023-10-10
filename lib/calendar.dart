import 'package:calendar/month.dart';
import 'package:flutter/material.dart';
import 'package:loop_page_view/loop_page_view.dart';

int year = DateTime.now().year;

class Calendar extends StatefulWidget {
  const Calendar({super.key});
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Column(children: [
      Container(
          color: Theme.of(context).hintColor,
          height: height * 0.05,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    year--;
                  });
                },
                icon: Icon(Icons.arrow_left,
                    size: height * 0.025, color: Colors.white),
              ),
              Text(
                year.toString(),
                style: TextStyle(
                    fontSize: height * 0.025,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    year++;
                  });
                },
                icon: Icon(Icons.arrow_right,
                    size: height * 0.025, color: Colors.white),
              ),
            ],
          )),
      SizedBox(
          height: height * 0.95,
          width: MediaQuery.sizeOf(context).width,
          child: LoopPageView.builder(
              itemBuilder: (context, index) {
                return Month(
                    num: (DateTime.now().month - 1 + index) % 12 + 1,
                    year: year);
              },
              itemCount: 12))
    ]);
  }
}
