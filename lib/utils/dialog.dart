import 'package:flutter/material.dart';

class SharyDialog {
  static show(String text, BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            width: 10,
          ),
          Container(margin: EdgeInsets.only(left: 7), child: Text(text)),
        ],
      ),
    );
  }
}
