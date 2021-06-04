import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chatly/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:validators/validators.dart';

class RegistrationScreen extends StatelessWidget {
  static const String id = "registration_screen";

  RegistrationScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  Future<void> _handleSignUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      print("hello");
      try {
        print(_emailController.text);
        final credential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (credential.user != null) {
          await credential.user!.updateDisplayName(_nameController.text.trim());
          await credential.user!.sendEmailVerification();
          await showOkAlertDialog(
            context: context,
            title: 'Email Sent',
            message: 'Please verify your email',
          );
          Navigator.pop(context);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: kPurpleColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: double.infinity),
                  const Text(
                    'Sign up',
                    style: TextStyle(fontFamily: 'VT323', fontSize: 64),
                  ),
                  const SizedBox(height: 64.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _nameController,
                      cursorColor: kDarkGrey,
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              8.0,
                            ),
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Field cannot be empty',
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _emailController,
                      cursorColor: kDarkGrey,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              8.0,
                            ),
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) =>
                          value != null && value.isNotEmpty && isEmail(value)
                              ? null
                              : 'Invalid email',
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        cursorColor: kDarkGrey,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                8.0,
                              ),
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) => value != null && value.length > 6
                            ? null
                            : 'Password must be greater than 6 characters',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kDarkGrey)),
                        onPressed: () => _handleSignUp(context),
                        child: const Text('Sign up'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
