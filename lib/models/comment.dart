import 'package:flutter/material.dart';
import 'package:shary/models/shary_user.dart';

class Comment {
  String uid;
  String body;
  SharyUser creator;
  String createdAt;

  Comment(
      {required this.uid,
      required this.body,
      required this.creator,
      required this.createdAt});
}
