import 'package:chatly/screens/login_screen.dart';
import 'package:chatly/screens/registration_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Chatly());
}

class Chatly extends StatelessWidget {
  const Chatly({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
      },
      initialRoute: LoginScreen.id,
    );
  }
}
