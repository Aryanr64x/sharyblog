import 'package:flutter/material.dart';


class SharyDialog {
  static show(String text) {
    return AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7), child: Text(text)),
        ],
      ),
    );
  }
}
