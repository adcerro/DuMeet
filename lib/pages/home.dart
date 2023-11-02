import 'package:calendar/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  HomeState createState() => HomeState();
}

DateTime _selectedDay = DateTime.now();
DateTime _focusedDay = DateTime.now();
final user = FirebaseAuth.instance.currentUser;
bool _visible = false;

class HomeState extends State<Home> {
  List<Widget> coreElements(BuildContext context) {
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
            _visible = true;
          });
        },
      )),
      const SizedBox(height: 20),
      AnimatedOpacity(
        opacity: _visible ? 1 : 0,
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
            ),
            const SizedBox(height: 20),
            Text(
              'Selecciona hora',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
                height: MediaQuery.sizeOf(context).height / 2,
                width: MediaQuery.sizeOf(context).width,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5),
                  itemBuilder: (context, index) {
                    return Text(index.toString());
                  },
                  itemCount: 10,
                ))
          ],
        ),
      )
    ];
  }

  Widget verticalLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programa tu cita'),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
          width: MediaQuery.sizeOf(context).width / 2,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              '${user?.email}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const Spacer(),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Log Out'))
          ])),
      body: SafeArea(
        child: ListView(
          children: coreElements(context),
        ),
      ),
    );
  }

  Widget horizontalLayout(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            width: MediaQuery.sizeOf(context).width / 2.5,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${user?.email}',
                      style: Theme.of(context).textTheme.labelLarge),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Log Out'))
                ])),
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
                children: coreElements(context),
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
