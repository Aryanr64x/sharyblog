// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shary/firebase/firestore_helper.dart';
import 'package:shary/models/shary_user.dart';
import 'package:shary/utils/shary_toast.dart';

class FollowUnfollow extends StatefulWidget {
  SharyUser profileUser;
  bool isFollowing;
  Function onFollowUnfollow;
  FollowUnfollow(
      {required this.profileUser,
      required this.isFollowing,
      required this.onFollowUnfollow});

  @override
  State<FollowUnfollow> createState() => _FollowUnfollowState();
}

class _FollowUnfollowState extends State<FollowUnfollow> {
  late bool isFollowing;
  @override
  void initState() {
    isFollowing = widget.isFollowing;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(
              (states) => Theme.of(context).primaryColor)),
      onPressed: _followUnfollow,
      child: Text(
        (isFollowing) ? "Unfollow" : "Follow",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  void _followUnfollow() async {
    print(isFollowing);
    final FireStoreHelper storeHelper = FireStoreHelper();
    late bool isSuccess;

    if (isFollowing) {
      setState(() {
        isFollowing = false;
      });
      widget.onFollowUnfollow(false);

      isSuccess = await storeHelper.unfollow(widget.profileUser.id,
          widget.profileUser.username, widget.profileUser.userAvatar);
    } else {
      setState(() {
        isFollowing = true;
      });
      widget.onFollowUnfollow(true);

      print("THIS METHOD IS CALLED");
      isSuccess = await storeHelper.follow(widget.profileUser.id,
          widget.profileUser.username, widget.profileUser.userAvatar);
    }
    if (!isSuccess) {
      setState(() {
        isFollowing = !isFollowing;
      });
      SharyToast.show("Oops! Something went wrong .");
    }
  }
}
