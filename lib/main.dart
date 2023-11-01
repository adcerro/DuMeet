import 'package:calendar/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar/pages/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initializeDateFormatting().then((_) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      //The SafeArea Widget prevents the app from overlapping with OS stuff
      //in phones it avoids using the space of the notification bar
      home: const Scaffold(
        body: SafeArea(child: Login()),
      ),
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.red[900],
          textTheme: GoogleFonts.ptSansTextTheme(textTheme)),
    );
  }
}
