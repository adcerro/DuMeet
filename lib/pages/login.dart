import 'package:flutter/material.dart';
import 'package:calendar/pages/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final EdgeInsets padding = const EdgeInsets.only(left: 15, right: 15);
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month_rounded,
              size: MediaQuery.sizeOf(context).width / 4),
          Text(
            'Welcome!',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Padding(
              padding: padding,
              child: TextFormField(
                decoration: InputDecoration(
                    label: const Text('User'),
                    labelStyle: Theme.of(context).textTheme.headlineSmall),
              )),
          Padding(
              padding: padding,
              child: TextFormField(
                decoration: InputDecoration(
                    label: const Text('Password'),
                    labelStyle: Theme.of(context).textTheme.headlineSmall),
                obscureText: true,
              )),
          TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Home();
                  },
                ));
              },
              style: Theme.of(context).textButtonTheme.style?.copyWith(
                  backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.primaryContainer)),
              child: const Text('Log In'))
        ]);
  }
}
