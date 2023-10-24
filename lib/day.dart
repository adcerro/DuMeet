import 'package:calendar/event_creator.dart';
import 'package:flutter/material.dart';

int _num = 1;
String _month = 'January';
int _year = DateTime.now().year;

class Day extends StatefulWidget {
  //The day has the information about the year and month it belongs to
  //in order to be capable of storing events
  Day({super.key, int num = 1, String month = 'January', int year = 2023}) {
    _num = num;
    _month = month;
    _year = year;
  }
  @override
  State<Day> createState() => _DayState();
}

class _DayState extends State<Day> {
  //This method formats the date at the top of the day hours
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
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        //AppBar Showing the excat date that was picked
        appBar: AppBar(
          title: Text('$_month ${day(_num)}, $_year',
              style: TextStyle(
                  fontSize: height * 0.035,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary)),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        //The stack widgets allows the floatting button in the corner over the list
        body: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            //We place the list in a sized box to prevent infinite dimensions error
            //We only specify height since it is our main axis
            SizedBox(
                height: height * 0.9,
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
            //Button with some padding to distance it from the corner
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          DialogRoute(
                              context: context,
                              builder: (context) {
                                return EventCreator(
                                    day: _num, month: _month, year: _year);
                              }));
                    },
                    child: const Icon(Icons.calendar_month_rounded)))
          ],
        ));
  }
}
