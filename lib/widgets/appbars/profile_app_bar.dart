// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shary/utils/display_picture.dart';
import 'package:shary/models/profile.dart';
import 'package:shary/models/shary_user.dart';
import 'package:shary/screens/profilescreens/connection_screen.dart';
import 'package:shary/widgets/userwidgets/follow_unfollow.dart';

class ProfileAppBar extends StatefulWidget {
  SharyUser profileUser;
  Profile profile;
  bool isFollowing;
  ProfileAppBar(
      {required this.profileUser,
      required this.profile,
      required this.isFollowing});

  @override
  State<ProfileAppBar> createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  late int _followersCount;

  @override
  void initState() {
    _followersCount = widget.profile.followersCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 250.0,
      stretch: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.fadeTitle],
        background: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                        child: DisplayPicture.display(
                            widget.profileUser.userAvatar, 75)),
                  ),
                  Expanded(
                    child: FollowUnfollow(
                        profileUser: widget.profileUser,
                        isFollowing: widget.isFollowing,
                        onFollowUnfollow: (bool follow) {
                          _onFollowOrUnFollow(follow);
                        }),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.profileUser.username,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.white),
                  ),
                  iconAsPerUser()
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.profile.postsCount.toString() + " posts",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        _goToConnectionScreen(true);
                      },
                      child: Text(
                        _followersCount.toString() + " followers",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                    child: Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          _goToConnectionScreen(false);
                        },
                        child: Text(
                          widget.profile.followingsCount.toString() +
                              " following",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget iconAsPerUser() {
    if (widget.profileUser.id == FirebaseAuth.instance.currentUser!.uid) {
      return IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.settings_rounded,
            color: Colors.white,
          ));
    } else {
      return IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_horiz_rounded,
            color: Colors.white,
          ));
    }
  }

  void _onFollowOrUnFollow(bool follow) {
    if (follow) {
      setState(() {
        _followersCount++;
      });
    } else {
      setState(() {
        _followersCount--;
      });
    }
  }

  void _goToConnectionScreen(bool areFollower) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ConnectionScreen(
          profileId: widget.profile.profileId, areFollowers: areFollower);
    }));
  }
}
