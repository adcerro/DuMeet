import 'package:flutter/material.dart';
import 'package:calendar/pages/home.dart';
import 'package:calendar/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final EdgeInsets padding = const EdgeInsets.only(left: 15, right: 15);
  TextEditingController _emailControl = TextEditingController();
  TextEditingController _passwordControl = TextEditingController();
  bool errorMessage = false;
  Widget verticalLayout(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: MediaQuery.of(context).size.width / 1.2,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Gestiona tus citas con tus profesores con comodidad",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.normal,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
              padding: padding,
              child: reusableTextField("Ingresa tu correo",
                  Icons.email_outlined, false, _emailControl)),
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: padding,
              child: reusableTextField(
                  "Ingresa tu contraseña", Icons.lock, true, _passwordControl)),
          Container(
            height: 30,
            alignment: Alignment.bottomCenter,
            child: Text(
              errorMessage
                  ? 'Su email o contraseña es incorrecto, intente de nuevo'
                  : '',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          uiButton(context, "Iniciar Sesión", () {
            FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _emailControl.text, password: _passwordControl.text)
                .then((value) {
              _emailControl.clear();
              _passwordControl.clear();
              setState(() {
                errorMessage = false;
              });

              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Home();
                },
              ));
            }, onError: (value) {
              setState(() {
                errorMessage = true;
              });
            });
          })
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight > 450) {
          return verticalLayout(context);
        } else {
          return ListView(children: [verticalLayout(context)]);
        }
      },
    );
  }
}
