import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shary/models/shary_user.dart';
import 'package:shary/screens/postscreens/new_post_screen.dart';
import 'package:shary/screens/profilescreens/search_screen.dart';
import 'package:shary/screens/authscreens/welcome_screen.dart';
import 'package:shary/widgets/appbars/appbar_profile_button.dart';

class AppBarHome extends StatelessWidget with PreferredSizeWidget {
  SharyUser authUser;
  Function onNewPost;

  AppBarHome({Key? key, required this.authUser, required this.onNewPost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      title: const Text("Shary"),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.id);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            onPressed: () async {
              var data = await Navigator.pushNamed(context, NewPostScreen.id);

              onNewPost(data);
            },
            icon: const Icon(Icons.add),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: AppbarProfileButton(profileUser: authUser),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            icon: const Icon(Icons.power_settings_new),
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
