import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shary/models/post.dart';
import 'package:shary/screens/new_post_screen.dart';
import 'package:shary/screens/profile_screen.dart';
import 'package:shary/screens/welcome_screen.dart';

class HomeAppBar extends StatelessWidget {
  Function(Post) onNewPostAdded;
  HomeAppBar({required this.onNewPostAdded});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Shary"),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            onPressed: () async {
              var data = await Navigator.pushNamed(context, NewPostScreen.id);

              Post newPost = data as Post;
              onNewPostAdded(newPost);
            },
            icon: Icon(Icons.add),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return ProfileScreen(
                  username: FirebaseAuth.instance.currentUser!.displayName!,
                  userAvatar: FirebaseAuth.instance.currentUser!.photoURL!,
                );
              }));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
              } catch (e) {
                print(e);
              }
            },
          ),
        ),
      ],
    );
  }
}
