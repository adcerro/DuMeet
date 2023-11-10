import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:calendar/classes/reservas.dart';
import 'package:intl/intl.dart'; // Add this import for DateFormat

FirebaseFirestore database = FirebaseFirestore.instance;

//FUNCIONES GET (ONE ELEMEMENT)

//Obtener usuario activo
String getCurrentUserUID() {
  User? user = FirebaseAuth.instance.currentUser;
  String uid = "";
  if (user != null) {
    uid = user.uid;
  } else {
    print('No user is currently authenticated.');
  }
  return uid;
}

//Obtener fecha de la reserva
Future<DateTime?> getDate(DocumentReference reference) async {
  try {
    final documentSnapshot = await reference.get();
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      final fechai = data['fecha_i'] as Timestamp;
      final date = fechai.toDate(); // Convert Timestamp to DateTime
      return date;
    } else {
      // Handle the case where the document doesn't exist
      return null;
    }
  } catch (e) {
    print('Error retrieving date: $e');
    return null;
  }
}

//Obtener datos de la reserva
Future<ReservaData> obtenerDatosDeReserva(DocumentReference reservaRef) async {
  final reservaSnapshot = await reservaRef.get();
  if (reservaSnapshot.exists) {
    final idProfesorRef =
        reservaSnapshot.get('id_profesor') as DocumentReference;
    final estado = reservaSnapshot.get('estado') as String;
    final fecha = reservaSnapshot.get('fecha') as Timestamp;

    final nombreProfesor = await getFullNameByReference(idProfesorRef);
    final imgUrl = await getURLImagenProfesor(idProfesorRef);

    return ReservaData(
      nombreProfesor: nombreProfesor,
      estado: estado,
      fecha: fecha.toDate().toUtc(),
      imgUrl: imgUrl,
    );
  }
  // En caso de que el documento de reserva no exista
  return ReservaData(
    nombreProfesor: 'Profesor Desconocido',
    estado: 'Desconocido',
    fecha: null,
    imgUrl:
        'https://guayacan02.uninorte.edu.co/4PL1CACI0N35/Fotos_Docentes/default.png', // Puedes definir una URL por defecto.
  );
}

//Obtener imagen del profesor
Future<String?> getURLImagenProfesor(DocumentReference idProfesorRef) async {
  try {
    DocumentSnapshot profesorSnapshot = await idProfesorRef.get();
    if (profesorSnapshot.exists) {
      Map<String, dynamic> data =
          profesorSnapshot.data() as Map<String, dynamic>;
      String imgUrl = data['img_url'] as String;
      return imgUrl;
    } else {
      // El documento del profesor no existe.
      return null;
    }
  } catch (e) {
    print('Error al obtener la URL de la imagen del profesor: $e');
    return null;
  }
}

//Obtener referencia del profesor con nombre completo
Future<DocumentReference?> getProfesorReferenceByFullName(
    String? fullName) async {
  try {
    final professorsCollection =
        FirebaseFirestore.instance.collection('profesores');

    final nameParts = fullName?.split(' ');

    if (nameParts != null && nameParts.length >= 2) {
      final firstName = nameParts[0];
      final lastName = nameParts.sublist(1).join(' ');

      final professorsQuery = await professorsCollection
          .where('nombre', isEqualTo: firstName)
          .where('apellido', isEqualTo: lastName)
          .limit(1)
          .get();

      if (professorsQuery.docs.isNotEmpty) {
        final professorDoc = professorsQuery.docs.first;
        return professorDoc.reference;
      }
    }

    // No se encontró ningún profesor con el nombre y apellido proporcionados.
    return null;
  } catch (e) {
    print('Error al buscar al profesor: $e');
    return null;
  }
}

//Obtener nombre completo con referencia
Future<String?> getFullNameByReference(DocumentReference reference) async {
  DocumentSnapshot professorDoc = await reference.get();
  if (professorDoc.exists) {
    final firstName = professorDoc['nombre'] ?? '';
    final lastName = professorDoc['apellido'] ?? '';
    final fullName = '$firstName $lastName';
    return fullName;
  }
}

//FUNCIONES GET (LISTA)

//Obtener profesores del estudiante activo
Future<List<String>> getProfesores() async {
  try {
    String uid = getCurrentUserUID();
    DocumentReference estudianteRef =
        FirebaseFirestore.instance.collection('estudiantes').doc(uid);
    DocumentSnapshot studentSnapshot = await estudianteRef.get();

    if (studentSnapshot.exists) {
      List<dynamic> clasesRefs = studentSnapshot.get('clases');
      List<String> profesoresData = [];

      for (var claseRef in clasesRefs) {
        if (claseRef is DocumentReference) {
          DocumentSnapshot claseSnapshot = await claseRef.get();

          if (claseSnapshot.exists) {
            DocumentReference professorReference =
                claseSnapshot.get('id_profesor');

            if (professorReference != null) {
              DocumentSnapshot professorSnapshot =
                  await professorReference.get();

              if (professorSnapshot.exists) {
                Map<String, dynamic> professorData =
                    professorSnapshot.data() as Map<String, dynamic>;
                String name = professorData['nombre'] ?? '';
                String lastName = professorData['apellido'] ?? '';

                if (name.isNotEmpty || lastName.isNotEmpty) {
                  String fullName = '$name $lastName';
                  profesoresData.add(fullName);
                }
              }
            }
          }
        }
      }

      return profesoresData;
    } else {
      return [];
    }
  } catch (e) {
    print('Error fetching data: $e');
    return [];
  }
}

//Obtener horarios para la cita en el día y profesor seleccionado
Future<List<DropdownMenuEntry<DateTime>>?> generateTimeSlots(
    DateTime selectedDate, String? profesor) async {
  try {
    CollectionReference reservasCol =
        FirebaseFirestore.instance.collection('reservas');
    final profesorReference = await getProfesorReferenceByFullName(profesor);
    final reservasQuery = await reservasCol
        .where('id_profesor', isEqualTo: profesorReference)
        .get();
    print(reservasQuery.docs.isNotEmpty);
    List<DropdownMenuEntry<DateTime>> timeSlots = [];
    for (int hour = 8; hour <= 17; hour++) {
      for (int minute = 0; minute <= 30; minute += 30) {
        if (hour != 12) {
          String timeSlotString =
              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
          DateTime timeSlot =
              selectedDate.add(Duration(hours: hour, minutes: minute));
          // Convert the time slot to a DropdownMenuEntry
          timeSlots.add(DropdownMenuEntry(
            value: timeSlot,
            label: timeSlotString,
          ));
        }
      }
    }

    if (reservasQuery.docs.isNotEmpty) {
      reservasQuery.docs.forEach((doc) {
        Timestamp reservationTime = doc['fecha_i'];
        DateTime reservedDateTime = reservationTime.toDate().toUtc();
        timeSlots.removeWhere((entry) {
          bool shouldRemove = (entry.value.hour == reservedDateTime.hour) &&
              (entry.value.minute == reservedDateTime.minute) &&
              (entry.value.day == reservedDateTime.day);
          return shouldRemove;
        });
      });
    }

    return timeSlots;
  } catch (e) {
    print('Error al buscar reservas $e');
    return null;
  }
}

//Obtener reservas del estudiante
Future<List<DocumentSnapshot>> getReservas() async {
  List<DocumentSnapshot> listaReservas = [];
  String uid = getCurrentUserUID();
  DocumentReference estudianteRef =
      FirebaseFirestore.instance.collection('estudiantes').doc(uid);
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('reservas')
      .where('id_estudiante', isEqualTo: estudianteRef)
      .get();

  if (querySnapshot != null) {
    listaReservas.addAll(querySnapshot.docs);
  }

  return listaReservas;
}

//FUNCIONES PARA GUARDAR EN BASE DE DATOS

//Guarda fecha de cita en base de datos
Future<bool> saveReserva(String? profesor, DateTime? fecha) async {
  print(fecha);
  try {
    String uid = getCurrentUserUID();
    DocumentReference estudianteRef =
        FirebaseFirestore.instance.collection('estudiantes').doc(uid);
    DocumentReference? profesorReference =
        await getProfesorReferenceByFullName(profesor);
    if (profesorReference == null) {
      print('Profesor no encontrado.');
      print(profesor);
      return false;
    }
    if (fecha != null) {
      await FirebaseFirestore.instance.collection("reservas").add({
        'id_estudiante': estudianteRef,
        'id_profesor': profesorReference,
        'fecha_i': fecha.toLocal(),
        'status': "ACTIVA"
      });
    }
    return true; // Operation was successful
  } catch (e) {
    print('Error saving reserva: $e');
    return false; // Operation failed
  }
}

Future<List<Map<String, dynamic>>> getReservasDetails() async {
  final List<Map<String, dynamic>> reservationsDetails = [];
  final List<DocumentSnapshot> reservaSnapshots = await getReservas();

  for (final reservaSnapshot in reservaSnapshots) {
    final DocumentReference idProfesorRef =
        reservaSnapshot.get('id_profesor') as DocumentReference;
    final String nombreProfesor =
        await getFullNameByReference(idProfesorRef) ?? 'Profesor Desconocido';
    final DateTime? fecha = await getDate(reservaSnapshot.reference);
    final DocumentSnapshot profesor = await idProfesorRef.get();
    final String img = profesor['img_url'];
    final DocumentReference ref = reservaSnapshot.reference;
    print(ref);
    reservationsDetails.add({
      'person': nombreProfesor,
      'date': fecha != null
          ? DateFormat('EEEE, MMM d h:mm a', 'es')
              .format(fecha.toUtc())
              .toString()
          : 'Fecha Desconocida',
      'img': img,
      'ref': ref,
    });
  }
  return reservationsDetails;
}
