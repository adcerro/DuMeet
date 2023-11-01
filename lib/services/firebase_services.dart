import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore database = FirebaseFirestore.instance;

Future<List> getStudents() async {
  List students = [];
  CollectionReference collectionReferenceStudents =
      database.collection('estudiantes');
  QuerySnapshot queryStudents = await collectionReferenceStudents.get();
  queryStudents.docs.forEach((element) {
    students.add(element.data());
  });

  return students;
}
