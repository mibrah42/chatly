import 'package:chatly/screens/chat_screen.dart';
import 'package:chatly/screens/login_screen.dart';
import 'package:chatly/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        AppEntry.id: (context) => const AppEntry(),
      },
      initialRoute: AppEntry.id,
    );
  }
}

class AppEntry extends StatelessWidget {
  static const String id = "app_entry";

  const AppEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return LoginScreen();
    } else {
      return ChatScreen(user: user);
    }
  }
}
