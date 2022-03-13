import 'dart:math';

import 'package:flutter/material.dart';

class LogoAnimation {
  late final AnimationController _animationController;
  LogoAnimation(TickerProvider vsync, Function onAnimate) {
    _animationController = AnimationController(
        vsync: vsync,
        duration: Duration(seconds: 8),
        lowerBound: 0,
        upperBound: 2 * pi);
    _animationController.addListener(() {
      onAnimate();
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.repeat();
      }
    });
  }

  void play() {
    _animationController.forward();
  }

  double value() {
    return _animationController.value;
  }

  void kill() {
    return _animationController.dispose();
  }
}
