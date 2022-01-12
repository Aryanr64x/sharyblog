import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shary/screens/home_screen.dart';
import 'package:shary/screens/new_post_screen.dart';
import 'package:shary/screens/sign_in_screen.dart';
import 'package:shary/screens/sign_up_screen.dart';
import 'package:shary/screens/sign_up_transition_screen.dart';
import 'package:shary/screens/welcome_screen.dart';

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
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        SignUpTransitionScreen.id: (context) => SignUpTransitionScreen(),
        SignInScreen.id: (context) => SignInScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        NewPostScreen.id: (context) => NewPostScreen(),
      },
      theme: ThemeData(
        primaryColor: Color(0xff223943),
      ),
    );
  }
}
