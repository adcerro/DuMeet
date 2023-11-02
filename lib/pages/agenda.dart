import 'package:flutter/material.dart';

class Agenda extends StatefulWidget {
  const Agenda({super.key});
  @override
  AgendaState createState() => AgendaState();
}

class AgendaState extends State<Agenda> {
  Widget verticalLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tus citas'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      //TODO: Appointment retreieval pending
      body: SafeArea(child: ListView.builder(itemBuilder: (context, index) {
        return ListTile(
          title: Text(index.toString()),
        );
      })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight > 450) {
          return verticalLayout(context);
        } else {
          return verticalLayout(context);
        }
      },
    );
  }
}
