import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calendar/services/firebase_services.dart';
import 'package:calendar/pages/agenda.dart';
import 'package:calendar/widgets/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

String? _profesor;
DocumentReference? _citaRef;
DateTime? cita;

class Reprogramar extends StatefulWidget {
  final Function()? reloadCallback;

  Reprogramar({
    super.key,
    required String profesor,
    required DocumentReference citaRef,
    this.reloadCallback,
  }) {
    _profesor = profesor;
    _citaRef = citaRef;
  }

  @override
  _ReprogramarState createState() => _ReprogramarState();
}

DateTime _focusedDay = DateTime.now();
DateTime _selectedDay = DateTime.now();

class _ReprogramarState extends State<Reprogramar> {
  List<DropdownMenuItem<DateTime>> timeSlots = [];

  @override
  void initState() {
    super.initState();
  }

  MenuStyle dropStyle = MenuStyle(
    backgroundColor: MaterialStatePropertyAll(Colors.grey[200]),
  );

  Future<void> updateDateTimeInDatabase(DateTime? cita) async {
    if (_citaRef != null) {
      await _citaRef!.update({'fecha_i': cita!.toLocal()});
      print(cita);
    }
  }

  Widget coreView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Selecciona Nueva Fecha y Hora',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          CustomCalendar(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              onDatePicked: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              }),
          const SizedBox(height: 20),
          FutureBuilder<List<DropdownMenuEntry<DateTime>>?>(
            future: generateTimeSlots(_selectedDay, _profesor),
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
          SizedBox(height: 20),
          uiButton(context, 'Guardar Nueva Fecha y Hora', () async {
            await updateDateTimeInDatabase(cita);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Cita reprogramada con éxito'),
            ));
            setState(() {
              _selectedDay = DateTime.now();
              _focusedDay = DateTime.now();
            });
            widget.reloadCallback?.call();
            Navigator.pop(context, true);
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reprogramar Cita'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxHeight < 400) {
            return ListView(children: [coreView()]);
          } else {
            return coreView();
          }
        }));
  }
}
