import 'package:flutter/material.dart';

class Post {
  String uid;
  String title;
  String body;
  int likesCount;
  int commentsCount;
  String creatorName;
  String? creatorAvatar;

  Post({
    required this.uid,
    required this.title,
    required this.body,
    required this.likesCount,
    required this.commentsCount,
    required this.creatorName,
    required this.creatorAvatar,
  });
}
