import 'package:flutter/material.dart';

class PageManager {
  static const REFRESH_OFFEST = -70.8899663140498;
  final PageController pageController = PageController();
  final Function onReachLast;
  final Function onRefresh;

  PageManager({required this.onReachLast, required this.onRefresh}) {
    pageController.addListener(_listener);
  }

  void _listener() {
    if (pageController.position.pixels ==
        pageController.position.maxScrollExtent) {
      onReachLast();
    } else if (pageController.position.pixels < REFRESH_OFFEST) {
      onRefresh();
    }
  }

  void goToFirst() {
    pageController.jumpToPage(0);
  }

  void stayOnNewPage(int postsLength) async {
    await Future.delayed(const Duration(microseconds: 0), () {
      pageController.animateToPage(postsLength - 1,
          curve: Curves.linear, duration: Duration(microseconds: 1));
    });
  }
}
