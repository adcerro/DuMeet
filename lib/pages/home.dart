import 'package:calendar/pages/agenda.dart';
import 'package:calendar/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  HomeState createState() => HomeState();
}

DateTime _selectedDay = DateTime.now();
DateTime _focusedDay = DateTime.now();
final user = FirebaseAuth.instance.currentUser;
bool _calendarVisible = false;
bool _timeVisible = false;
String? docente;
DateTime? cita;

class HomeState extends State<Home> {
  List<Widget> coreElements() {
    return [
      Text(
        'Selecciona con quien requieres la cita',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      Center(
          child: DropdownMenu<String>(
        dropdownMenuEntries: const [
          DropdownMenuEntry(value: 'Ludy', label: 'Ludy'),
          DropdownMenuEntry(value: 'Marquez', label: 'Marquez'),
          DropdownMenuEntry(value: 'Pava', label: 'Pava'),
          DropdownMenuEntry(value: 'Daladier', label: 'Daladier'),
          DropdownMenuEntry(value: 'Rocio', label: 'Rocio')
        ],
        onSelected: (value) {
          setState(() {
            docente = value;
            _calendarVisible = true;
          });
        },
      )),
      const SizedBox(height: 20),
      AnimatedOpacity(
        opacity: _calendarVisible ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        child: Column(
          children: [
            Text(
              'Selecciona fecha',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            CustomCalendar(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              onDatePicked: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _timeVisible = true;
                  });
                }
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      AnimatedOpacity(
          opacity: _timeVisible ? 1 : 0,
          duration: const Duration(milliseconds: 500),
          child: Column(children: [
            Text(
              'Selecciona hora',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            //TODO: Establecer las horas disponibles de cada docente
            DropdownMenu<DateTime>(
              dropdownMenuEntries: [
                DropdownMenuEntry(
                    value: _selectedDay.copyWith(hour: 6, minute: 0),
                    label: '6:00 am'),
                DropdownMenuEntry(
                    value: _selectedDay.copyWith(hour: 6, minute: 30),
                    label: '6:30 am'),
                DropdownMenuEntry(
                    value: _selectedDay.copyWith(hour: 7, minute: 0),
                    label: '7:00 am'),
                DropdownMenuEntry(
                    value: _selectedDay.copyWith(hour: 7, minute: 30),
                    label: '7:30 am'),
                DropdownMenuEntry(
                    value: _selectedDay.copyWith(hour: 8, minute: 0),
                    label: '8:00 am')
              ],
              onSelected: (value) {
                cita = value;
              },
            ),
            const SizedBox(height: 20),
            uiButton(context, 'Programar cita', () {
              //TODO: Código para registro de citas en base de datos
              print('$docente | $cita');
              Navigator.of(context).push(DialogRoute(
                  context: context,
                  builder: (context) {
                    if (docente == null || cita == null) {
                      return errorDialog(context: context, text: 'Error');
                    }
                    return successDialog(
                        context: context,
                        text: 'Programado exitosamente'); // o errorDialog();
                  }));
            })
          ]))
    ];
  }

  Widget drawerElements() {
    return SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(
        height: 10,
      ),
      Text(
        '${user?.email}',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      const SizedBox(
        height: 10,
      ),
      ListTile(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const Agenda();
            },
          ));
        },
        leading: const Icon(Icons.list),
        title: const Text('Mis citas'),
      ),
      const Spacer(),
      ListTile(
        onTap: () {
          _calendarVisible = false;
          _timeVisible = false;
          _selectedDay = DateTime.now();
          _focusedDay = DateTime.now();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          super.deactivate();
          super.dispose();
          //TODO: Logout logic
        },
        leading: const Icon(Icons.exit_to_app),
        title: const Text('Cerrar Sesión'),
      )
    ]));
  }

  Widget verticalLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programa tu cita'),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
          width: MediaQuery.sizeOf(context).width / 2, child: drawerElements()),
      body: SafeArea(
        child: ListView(
          children: coreElements(),
        ),
      ),
    );
  }

  Widget horizontalLayout(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            width: MediaQuery.sizeOf(context).width / 2.5,
            child: drawerElements()),
        body: SafeArea(
            child: Row(
          children: [
            RotatedBox(
                quarterTurns: 5,
                child: AppBar(
                  leading: RotatedBox(
                      quarterTurns: 1,
                      child: DrawerButton(
                        style: ButtonStyle(
                            foregroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.onPrimary)),
                      )),
                  backgroundColor: Theme.of(context).primaryColor,
                )),
            Expanded(
              child: ListView(
                children: coreElements(),
              ),
            )
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 450) {
        return verticalLayout(context);
      } else {
        return horizontalLayout(context);
      }
    });
  }
}
