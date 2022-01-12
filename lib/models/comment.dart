import 'package:flutter/material.dart';

class Comment {
  String uid;
  String body;

  String creatorName;
  String creatorAvatar;

  Comment(
      {required this.uid,
      required this.body,
      required this.creatorName,
      required this.creatorAvatar});
}
