// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:shary/utils/field_type.dart';

class SharyInput extends StatelessWidget {
  Function(String) onChanged;
  String? Function(String?) validators;
  String hintText;
  String fieldType;
  int maxLines;

  SharyInput(
      {required this.onChanged,
      required this.validators,
      required this.hintText,
      required this.fieldType,
      required this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      obscureText: (fieldType == FieldType.PASSWORD) ? true : false,
      onChanged: onChanged,
      validator: validators,
      keyboardType: (fieldType == FieldType.EMAIL)
          ? TextInputType.emailAddress
          : TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontWeight: FontWeight.bold),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
