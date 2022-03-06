import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shary/display_picture.dart';

class ProfileAppBar extends StatelessWidget {
  String username;
  String? userAvatar;
  ProfileAppBar({required this.username, required this.userAvatar});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 249.0,
      stretch: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.fadeTitle],
        background: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              DisplayPicture.display(userAvatar, 75),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.white),
                  ),
                  iconAsPerUser()
                ],
              ),
              Row(
                children: const [
                  Expanded(
                    child: Center(
                      child: Text(
                        "21 posts",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Center(
                    child: Text(
                      "789 followers",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )),
                  Expanded(
                    child: Center(
                      child: Text(
                        "75 follows",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
    if ("username" == FirebaseAuth.instance.currentUser!.displayName) {
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
}
