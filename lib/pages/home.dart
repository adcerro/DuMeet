import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  HomeState createState() => HomeState();
}

DateTime _selectedDay = DateTime.now();
DateTime _focusedDay = DateTime.now();

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Programa tu cita!'),
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: Drawer(
            width: MediaQuery.sizeOf(context).width / 2,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Usuario aqui'),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Log Out'))
                ])),
        body: SafeArea(
            child: ListView(children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.headlineSmall?.fontFamily,
                    fontSize:
                        Theme.of(context).textTheme.headlineSmall?.fontSize)),
            calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                    color: Theme.of(context).hintColor, shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle)),
          )
        ])));
  }
}
