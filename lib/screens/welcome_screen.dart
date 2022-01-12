import 'package:flutter/material.dart';
import 'package:shary/screens/sign_in_screen.dart';
import 'package:shary/screens/sign_up_screen.dart';
import 'package:shary/widgets/primary_button_widget.dart';

class WelcomeScreen extends StatelessWidget {
  static final String id = 'welcome';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            Hero(
              tag: 'logo',
              child: Image(
                image: AssetImage('images/logo.png'),
                height: 400.0,
                width: 400.0,
              ),
            ),
            AppPrimaryButton(
                title: "Sign In",
                onTap: () {
                  Navigator.pushNamed(context, SignInScreen.id);
                }),
            AppPrimaryButton(
                title: "Sign Up",
                onTap: () {
                  Navigator.pushNamed(context, SignUpScreen.id);
                }),
          ],
        ),
      ),
    );
  }
}
