import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shary/dialog.dart';
import 'package:shary/error.dart';
import 'package:shary/screens/home_screen.dart';
import 'package:shary/widgets/primary_button_widget.dart';

class SignInScreen extends StatefulWidget {
  static final String id = 'sign_in';
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

// task tonight.....study about containers....
class _SignInScreenState extends State<SignInScreen> {
  String? email;
  String? password;
  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _emailValidate = true;
  bool _passwordValidate = true;

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
                Hero(
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                  ),
                  validator: (String? value) {
                    if (value == null || value == '') {
                      return "Please enter an email id";
                    }
                  },
                  onChanged: (String value) {
                    email = value;
                  },
                ),
                SizedBox(
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
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    errorText:
                        _passwordValidate ? null : "Please create a password",
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                AppPrimaryButton(
                    title: "Sign In",
                    onTap: () async {
                      if (_formkey.currentState!.validate()) {
                        showLoaderDialog(context);
                        try {
                          final user = await auth.signInWithEmailAndPassword(
                              email: email!, password: password!);
                          if (user != null) {
                            Navigator.popAndPushNamed(context, HomeScreen.id);
                          }
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
        return SharyDialog.show("Signing In");
      },
    );
  }
}
