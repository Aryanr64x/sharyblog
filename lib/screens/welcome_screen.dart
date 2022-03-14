// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shary/animations/logo_animation.dart';
import 'package:shary/screens/auth_screen.dart';

import 'package:shary/widgets/primary_button_widget.dart';

class WelcomeScreen extends StatefulWidget {
  static final String id = 'welcome';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final LogoAnimation _logoAnimation;
  @override
  void initState() {
    _logoAnimation = LogoAnimation(this, () {
      setState(() {});
    });
    _logoAnimation.play();
    super.initState();
  }

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
              child: Transform.rotate(
                angle: _logoAnimation.value(),
                child: Image(
                  image: AssetImage('images/logo.png'),
                  height: 300.0,
                  width: 300.0,
                ),
              ),
            ),
            Text(
              "SHARY",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 20,
            ),
            AppPrimaryButton(
                title: "Get Started",
                onTap: () {
                  Navigator.popAndPushNamed(context, AuthScreen.id);
                }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logoAnimation.kill();
    super.dispose();
  }
}
