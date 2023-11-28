import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calendar/services/firebase_services.dart';
import 'package:calendar/pages/reprogramar.dart';

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  AgendaState createState() => AgendaState();
}

class AgendaState extends State<Agenda> {
  void reloadAgenda() {
    setState(() {});
  }

  AlertDialog cancelDialog(DocumentReference ref) {
    return AlertDialog(
      title: const Text('¿Desea cancelar la cita?'),
      actions: [
        TextButton(
          onPressed: () async {
            print(ref);
            ref.update({'status': 'CANCELADO'}).then((value) {
              print('Document Deleted');
            }).catchError((error) {
              print('Failed to delete document: $error');
            });
            Navigator.pop(context);

            // Show a snackbar
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Cita cancelada',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              backgroundColor: Colors.red,
            ));

            // Reload the page
            setState(() {});
          },
          child: const Text('Si'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        )
      ],
    );
  }

  Card appointment({
    String person = '',
    String date = '',
    String img = '',
    DocumentReference? ref,
    VoidCallback? onCancelPressed,
    VoidCallback? onReButtonPressed,
  }) {
    String? url = img;
    List<String> dateTimeParts = date.split(" ");
    String formattedDate = dateTimeParts.sublist(0, 3).join(" ");
    String formattedTime = dateTimeParts.sublist(3).join(" ");

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.circular(15) // Set the background color
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        person,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Icon(Icons.calendar_today, color: Color(0xff3b3b3b)),
                          SizedBox(width: 5),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Color(0xff3b3b3b),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.access_time, color: Color(0xff3b3b3b)),
                          SizedBox(width: 5),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Color(0xff3b3b3b),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(url ?? ''),
                        radius: 50,
                      )),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: onCancelPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                  ),
                  child:
                      Text('Cancelar', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: onReButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text('Reprogramar',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tus citas'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: getReservasDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final reservationsDetails = snapshot.data ?? [];
              if (reservationsDetails.length != 0) {
                return ListView.builder(
                  itemCount: reservationsDetails.length,
                  itemBuilder: (context, index) {
                    final details = reservationsDetails[index];
                    return appointment(
                      person: details['person'] ?? 'Nombre Desconocido',
                      date: details['date'] ?? 'Detalles Desconocidos',
                      img: details['img'] ?? '',
                      ref: details['ref'] ?? '',
                      onCancelPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return cancelDialog(details['ref']);
                          },
                        );
                      },
                      onReButtonPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Reprogramar(
                              profesor: details['person'],
                              citaRef: details['ref'],
                              reloadCallback: () {
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Icon(Icons.calendar_month),
                      Text("No tienes citas agendadas")
                    ]));
              }
            }
          },
        ),
      ),
    );
  }
}
