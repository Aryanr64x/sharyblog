// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shary/dialog.dart';
import 'package:shary/error.dart';
import 'package:shary/firebase/firestore_helper.dart';
import 'package:shary/screens/home_screen.dart';
import 'package:shary/screens/sign_up_transition_screen.dart';
import 'package:shary/widgets/primary_button_widget.dart';
import 'package:shary/widgets/sign_in_form.dart';
import 'package:shary/widgets/sign_up_form.dart';

class AuthScreen extends StatefulWidget {
  static final String id = "auth";
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showSignIn = false;
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            Image(
              image: AssetImage('images/logo.png'),
              height: 200.0,
              width: 200.0,
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 700),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: (_showSignIn)
                  ? SignInForm(
                      _signInFormKey,
                      onEmail: (email) {
                        _email = email;
                      },
                      onPassword: (password) {
                        _password = password;
                      },
                    )
                  : SignUpForm(
                      _signUpFormKey,
                      onEmail: (email) {
                        _email = email;
                      },
                      onPassword: (password) {
                        _password = password;
                      },
                    ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppPrimaryButton(
                    title: (_showSignIn) ? "Sign In" : "Sign Up",
                    onTap: () async {
                      if (_showSignIn) {
                        _signIn();
                      } else {
                        _signUp();
                      }
                    }),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _showSignIn = !_showSignIn;
                      });
                    },
                    child: Text(
                      (_showSignIn)
                          ? "Dont have an account?"
                          : "Already have an account?",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    if (_signInFormKey.currentState!.validate()) {
      _showLoaderDialog(context);
      try {
        final user = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        if (user != null) {
          // First pop is to pop the dialog
          Navigator.of(context).pop();
          Navigator.popAndPushNamed(context, HomeScreen.id);
        }
      } on FirebaseException catch (e) {
        Navigator.of(context).pop();
        print("HERE GOES TEH ERROR CODE" + e.code);
        Error.show(e);
      }
    }
  }

  void _signUp() async {
    if (_signUpFormKey.currentState!.validate()) {
      _showLoaderDialog(context);
      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        await FireStoreHelper().createProfile(user.user!.uid);
        Navigator.of(context).pop();
        Navigator.popAndPushNamed(context, SignUpTransitionScreen.id);
      } on FirebaseException catch (e) {
        Navigator.of(context).pop();

        Error.show(e);
      }
    }
  }

  _showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SharyDialog.show(
            (_showSignIn) ? "Signing In.." : "Signing up..", context);
      },
    );
  }
}
