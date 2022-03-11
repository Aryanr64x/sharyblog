import 'package:flutter/cupertino.dart';

class ReactAnimation {
  late AnimationController _animationController;
  late Animation _animation;

  ReactAnimation(TickerProvider ticker, Function onChange) {
    _animationController = AnimationController(
        vsync: ticker,
        duration: Duration(milliseconds: 200),
        lowerBound: 0,
        upperBound: 1);

    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.bounceInOut);

    _animationController.addListener(() {
      onChange();
    });
  }

  double iconSize() {
    if (_animation.value == 0) {
      return 24;
    } else {
      return _animation.value * 24;
    }
  }

  void animate() {
    _animationController.reset();
    _animationController.forward();
  }
}
