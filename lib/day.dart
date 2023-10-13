import 'package:flutter/material.dart';

int _num = 1;
String _month = 'January';
int _year = DateTime.now().year;

class Day extends StatefulWidget {
  Day({super.key, int num = 1, String month = 'January', int year = 2023}) {
    _num = num;
    _month = month;
    _year = year;
  }
  @override
  State<Day> createState() => _DayState();
}

class _DayState extends State<Day> {
  String day(int num) {
    switch (num % 10) {
      case 1:
        if (num % 100 == 11) return '${num}th';
        return '${num}st';
      case 2:
        if (num % 100 == 12) return '${num}th';
        return '${num}nd';
      case 3:
        if (num % 100 == 13) return '${num}th';
        return '${num}rd';
      default:
        return '${num}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(
        title: Text('$_month ${day(_num)}, $_year'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.9,
              child: ListView.builder(
                itemCount: 24,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Text(
                        '${index < 10 ? 0 : ''}${index.toString()}:00',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const Expanded(
                          child: Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ))
                    ],
                  );
                },
              )),
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                  onPressed: () {
                    print('Add Event');
                  },
                  child: const Icon(Icons.calendar_month_rounded)))
        ],
      )
    ]);
  }
}
