import 'package:flutter/material.dart';
import 'package:calendar/pages/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_month_rounded),
          const Text('Welcome!'),
          TextFormField(
            decoration: const InputDecoration(label: Text('User')),
          ),
          TextFormField(
            decoration: const InputDecoration(label: Text('Password')),
            obscureText: true,
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Home();
                  },
                ));
              },
              child: const Text('Log In'))
        ]);
  }
}
