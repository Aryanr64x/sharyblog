import 'package:flutter/material.dart';

class Profile {
  String profileId;
  int followersCount;
  int followingsCount;
  int postsCount;

  Profile(
      {required this.profileId,
      required this.followersCount,
      required this.followingsCount,
      required this.postsCount});
}
