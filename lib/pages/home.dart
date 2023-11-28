import 'package:calendar/pages/agenda.dart';
import 'package:calendar/services/firebase_services.dart';
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

bool _calendarVisible = false;
bool _timeVisible = false;
String? docente;
String? motivo;
DateTime? cita;

class HomeState extends State<Home> {
  User? user;
  Future<List<String>>? profesoresData;
  Future<List<DropdownMenuEntry<DateTime>>>? timeslots;
  TextEditingController _motiveControl = TextEditingController();

  List<DropdownMenuEntry<String>> dropdownMenuEntries = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    // Start fetching the list of profesores.
    profesoresData = getProfesores();
  }

  MenuStyle dropStyle = MenuStyle(
    backgroundColor: MaterialStatePropertyAll(Colors.grey[200]),
  );

  List<Widget> coreElements() {
    double size = MediaQuery.sizeOf(context).width / 12 < 32
        ? MediaQuery.sizeOf(context).width / 12
        : 32;
    return [
      Text(
        'Selecciona con quien requieres la cita',
        style:
            Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: size),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      Center(
        child: FutureBuilder<List<String>>(
          future: profesoresData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while fetching data.
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Handle errors if the request fails.
              return Text('Error: ${snapshot.error}');
            } else {
              List<String>? profesores = snapshot.data;
              if (profesores != null) {
                dropdownMenuEntries = profesores.map((userName) {
                  return DropdownMenuEntry(value: userName, label: userName);
                }).toList();
              }
              return DropdownMenu<String>(
                menuStyle: dropStyle,
                dropdownMenuEntries: dropdownMenuEntries,
                onSelected: (value) {
                  setState(() {
                    docente = value;
                    _calendarVisible = true;
                  });
                },
              );
            }
          },
        ),
      ),
      const SizedBox(height: 20),
      AnimatedOpacity(
        opacity: _calendarVisible ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        child: Column(
          children: [
            Text(
              'Selecciona fecha',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: size),
              textAlign: TextAlign.center,
            ),
            CustomCalendar(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              onDatePicked: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _timeVisible = true;
                });
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      AnimatedOpacity(
        opacity: _timeVisible ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        child: Column(
          children: [
            Text(
              'Selecciona hora',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: size),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<DropdownMenuEntry<DateTime>>?>(
              future: generateTimeSlots(_selectedDay, docente),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<DropdownMenuEntry<DateTime>> timeSlots =
                      snapshot.data ?? [];
                  return DropdownMenu<DateTime>(
                    menuStyle: dropStyle,
                    dropdownMenuEntries: timeSlots,
                    onSelected: (value) {
                      cita = value;
                    },
                  );
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Motivo de la cita',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: size),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ))),
                  maxLines: 5,
                  controller: _motiveControl,
                )),
            const SizedBox(
              height: 20,
            ),
            uiButton(context, 'Programar cita', () {
              //Código para registro de citas en base de datos
              if (docente == null || cita == null) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return errorDialog(context: context, text: 'Error');
                  },
                );
              } else {
                saveReserva(docente, cita, _motiveControl.text).then((result) {
                  if (result) {
                    // Reset and hide the calendar and dropdown
                    setState(() {
                      _selectedDay = DateTime.now();
                      _focusedDay = DateTime.now();
                      _timeVisible = false;
                      _calendarVisible = false;
                      _motiveControl.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                      _controller.jumpTo(0);
                    });

                    showDialog(
                        context: context,
                        builder: (context) {
                          return successDialog(
                            context: context,
                            text: 'Programado exitosamente',
                          );
                        });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return errorDialog(context: context, text: 'Error');
                      },
                    );
                  }
                });
              }
            }),
          ],
        ),
      ),
    ];
  }

  Widget drawerElements() {
    return SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
          alignment: AlignmentDirectional.bottomCenter,
          height: MediaQuery.sizeOf(context).height / 6,
          color: Theme.of(context).primaryColor,
          child: Text(
            '${user?.email}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold),
          )),
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
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          dispose();
          FirebaseAuth.instance.signOut();
        },
        leading: const Icon(Icons.exit_to_app),
        title: const Text('Cerrar Sesión'),
      )
    ]));
  }

  Color drawerBackground = Colors.white;
  ScrollController _controller = ScrollController();

  Widget verticalLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programa tu cita'),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
          backgroundColor: drawerBackground,
          width: MediaQuery.sizeOf(context).width / 2,
          child: drawerElements()),
      body: SafeArea(
        child: ListView(
          controller: _controller,
          children: coreElements(),
        ),
      ),
    );
  }

  Widget horizontalLayout(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            backgroundColor: drawerBackground,
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
                controller: _controller,
                children: coreElements(),
              ),
            )
          ],
        )));
  }

  @override
  void dispose() {
    _calendarVisible = false;
    _timeVisible = false;
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    //super.deactivate();
    //super.dispose();
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
