import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shary/utils/shary_toast.dart';

class Error {
  static show(FirebaseException e) {
    if (e.code == 'email-already-in-use') {
      SharyToast.show("This email id has been taken ! try something else");
    } else if (e.code == 'invalid-email') {
      SharyToast.show("This is not a  valid email address");
    } else if (e.code == 'invalid-password') {
      SharyToast.show("The password You have entered is wrong ");
    } else if (e.code == 'user-not-found') {
      SharyToast.show(
          "This email id has not been registered yet, please signup first");
    } else if (e.code == 'weak-password') {
      SharyToast.show(
          "Please enter a strong enough password with atleast 6 charcaters");
    } else {
      SharyToast.show("We have some problemm now, try againn later");
    }
  }
}
