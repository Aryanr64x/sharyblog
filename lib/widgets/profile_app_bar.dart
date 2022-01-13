import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget {
  String username;
  String userAvatar;
  ProfileAppBar({required this.username, required this.userAvatar});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 249.0,
      stretch: true,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.fadeTitle],
        background: Column(
          children: [
            CircleAvatar(
              radius: 75.0,
              backgroundImage: Image.network(
                      "https://upload.wikimedia.org/wikipedia/en/c/c6/Jesse_Pinkman_S5B.png")
                  .image,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Jessie Pinkman",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    "789 followers",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                Expanded(
                  child: Center(
                    child: Text(
                      "75 follows",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget iconAsPerUser() {
    if (username == FirebaseAuth.instance.currentUser!.displayName) {
      return IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.settings,
          ));
    } else {
      return IconButton(
        onPressed: () {},
        icon: Icon(Icons.more_vert),
      );
    }
  }
}
