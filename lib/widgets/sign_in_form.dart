// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shary/error.dart';
import 'package:shary/screens/home_screen.dart';
import 'package:shary/screens/sign_up_screen.dart';
import 'package:shary/utils/field_type.dart';
import 'package:shary/widgets/primary_button_widget.dart';
import 'package:shary/widgets/shary_input.dart';

class SignInForm extends StatelessWidget {
  var _formkey;
  Function onEmail;
  Function onPassword;
  SignInForm(this._formkey, {required this.onEmail, required this.onPassword});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30.0,
                fontWeight: FontWeight.w900),
          ),
          SharyInput(
              onChanged: (String value) {
                onEmail(value);
              },
              validators: (String? value) {
                if (value == null || value == '') {
                  return "Please enter an email id";
                }
              },
              hintText: "Enter your email..",
              fieldType: FieldType.EMAIL,
              maxLines: 1),
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
          SharyInput(
              onChanged: (String value) {
                onPassword(value);
              },
              validators: (String? value) {
                if (value == null || value == '') {
                  return "You have forgotten to enter your password";
                }
              },
              hintText: "Enter your password..",
              fieldType: FieldType.PASSWORD,
              maxLines: 1),
        ],
      ),
    );
  }
}
