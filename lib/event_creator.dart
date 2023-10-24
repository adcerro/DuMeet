import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

int _day = 1;
String _month = 'January';
int _year = DateTime.now().year;

class EventCreator extends StatefulWidget {
  EventCreator(
      {super.key, int day = 1, String month = 'January', int year = 2023}) {
    _day = day;
    _month = month;
    _year = year;
  }
  @override
  State<EventCreator> createState() => _EventCreatorState();
}

class _EventCreatorState extends State<EventCreator> {
  final _pad = const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5);
  TimeOfDay? startTime;
  TimeOfDay? finishTime;
  Color doneS = Colors.red;
  Color doneF = Colors.red;
  String title = '';
  var path = 'test.db';

  @override
  Widget build(BuildContext context) {
    TextStyle? style = Theme.of(context).textTheme.labelLarge;
    if (kIsWeb) {
      // Change default factory on the web
      databaseFactory = databaseFactoryFfiWeb;
      path = 'test.db';
    }
    // open the database

    return Dialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: _pad,
                  child: TextFormField(
                    decoration: InputDecoration(
                        label: const Text('Event Title'), labelStyle: style),
                    onChanged: (value) {
                      title = value;
                    },
                  )),
              SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(doneS),
                            foregroundColor:
                                const MaterialStatePropertyAll(Colors.black)),
                        child: const Text('Start Time'),
                        onPressed: () async {
                          startTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );
                          if (startTime != null) {
                            setState(() {
                              doneS = Colors.green;
                            });
                          }
                        },
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(doneF),
                            foregroundColor:
                                const MaterialStatePropertyAll(Colors.black)),
                        child: const Text('Finish Time'),
                        onPressed: () async {
                          finishTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );
                          if (finishTime != null) {
                            setState(() {
                              doneF = Colors.green;
                            });
                          }
                        },
                      )
                    ],
                  )),
              IconButton(
                onPressed: () {
                  if (startTime != null && finishTime != null) {
                    print(
                        '$title: $_month $_day, $_year ${startTime?.hour}:${startTime?.minute} - ${finishTime?.hour}:${finishTime?.minute}');
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Error')));
                  }
                },
                icon: const Icon(Icons.check),
              )
            ]));
  }
}
