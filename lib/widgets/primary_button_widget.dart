import 'package:flutter/material.dart';

class AppPrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  AppPrimaryButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(title),
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith((states) =>
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        minimumSize:
            MaterialStateProperty.resolveWith((states) => Size(150.0, 40.0)),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
