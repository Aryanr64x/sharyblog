import 'package:flutter/material.dart';
import 'package:shary/models/shary_user.dart';
import 'package:shary/screens/profilescreens/profile_screen.dart';

class AppbarProfileButton extends StatelessWidget {
  SharyUser profileUser;
  AppbarProfileButton({Key? key, required this.profileUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.account_circle),
      onPressed: () {
        Navigator.of(context).push(_createRoute());
      },
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ProfileScreen(profileUser),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
