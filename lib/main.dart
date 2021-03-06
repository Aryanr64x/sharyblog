import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shary/screens/authscreens/auth_screen.dart';
import 'package:shary/screens/home_screen.dart';
import 'package:shary/screens/postscreens/new_post_screen.dart';
import 'package:shary/screens/profilescreens/profile_screen.dart';
import 'package:shary/screens/profilescreens/search_screen.dart';

import 'package:shary/screens/authscreens/sign_up_transition_screen.dart';
import 'package:shary/screens/authscreens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initial(),
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        AuthScreen.id: (context) => AuthScreen(),
        SignUpTransitionScreen.id: (context) => SignUpTransitionScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        NewPostScreen.id: (context) => NewPostScreen(),
        SearchScreen.id: (context) => SearchScreen()
      },
      theme: ThemeData(
        primaryColor: Color(0xff223943),
      ),
    );
  }

  String initial() {
    if (FirebaseAuth.instance.currentUser != null) {
      return HomeScreen.id;
    } else {
      return WelcomeScreen.id;
    }
  }
}
