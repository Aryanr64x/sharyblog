import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shary/dialog.dart';
import 'package:shary/error.dart';
import 'package:shary/screens/home_screen.dart';
import 'package:shary/screens/sign_up_transition_screen.dart';
import 'package:shary/shary_toast.dart';
import 'package:shary/widgets/primary_button_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  static final String id = 'sign_up';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? email;
  String? password;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Hero(
                  tag: 'logo',
                  child: Image(
                    image: AssetImage('images/logo.png'),
                    height: 200.0,
                    width: 200.0,
                  ),
                ),
                Text(
                  "Email",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900),
                ),
                TextFormField(
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please provide an email ID";
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: "Enter your email"),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Password",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900),
                ),
                TextFormField(
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Create  a new password",
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                AppPrimaryButton(
                    title: "SignUp",
                    onTap: () async {
                      if (_formkey.currentState!.validate()) {
                        showLoaderDialog(context);
                        try {
                          await firebaseAuth.createUserWithEmailAndPassword(
                              email: email!, password: password!);
                          Navigator.popAndPushNamed(
                              context, SignUpTransitionScreen.id);
                        } on FirebaseException catch (e) {
                          Navigator.pop(context);
                          Error.show(e);
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SharyDialog.show("Signing up");
      },
    );
  }
}
