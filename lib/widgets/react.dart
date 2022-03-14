// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shary/animations/react_animation.dart';
import 'package:shary/firebase/firestore_helper.dart';
import 'package:provider/provider.dart';
import 'package:shary/shary_toast.dart';
import '../post_data.dart';

import 'package:shary/models/post.dart';

class ReactPanel extends StatefulWidget {
  String name = "name";
  @override
  State<ReactPanel> createState() => _ReactPanelState();
}

class _ReactPanelState extends State<ReactPanel>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  bool? isLiked;

  String get myname => widget.name;
  final FireStoreHelper storeHelper = FireStoreHelper();

  late final ReactAnimation _reactAnimation;

  @override
  void initState() {
    _reactAnimation = ReactAnimation(this, () {
      setState(() {});
    });
    checkIsLiked();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        likeOrUnlikeIcon(),
        Text("${Provider.of<PostData>(context, listen: false).post.likesCount}")
      ],
    );
  }

  Widget likeOrUnlikeIcon() {
    if (isLoading) {
      return Text('');
    } else {
      if (isLiked!) {
        return IconButton(
          onPressed: () {
            likeOrUnlike();
          },
          icon: Icon(
            Icons.favorite_rounded,
            size: _reactAnimation.iconSize(),
          ),
          color: Theme.of(context).primaryColor,
        );
      } else {
        return IconButton(
          onPressed: () {
            likeOrUnlike();
          },
          icon: Icon(
            Icons.favorite_border_rounded,
            size: _reactAnimation.iconSize(),
          ),
          color: Theme.of(context).primaryColor,
        );
      }
    }
  }

  void checkIsLiked() async {
    var data = await storeHelper
        .isLiked(Provider.of<PostData>(context, listen: false).post.uid);
    if (data == null) {
      SharyToast.show(
          "We are encountering some error.. Make sure your internet connection is right");
    } else {
      isLiked = data;
      setState(() {
        isLoading = false;
      });
    }
  }

  void likeOrUnlike() async {
    Post post = Provider.of<PostData>(context, listen: false).post;
    if (isLiked!) {
      setState(() {
        isLiked = false;

        Provider.of<PostData>(context, listen: false).decreaseLikesCount();
      });
      _reactAnimation.animate();

      var isSuccessful = await storeHelper.dislike(post.uid, post.likesCount);

      if (!isSuccessful) {
        SharyToast.show(
            "We cannot complete that action currently . Please check your internet connection and try again");
        setState(() {
          isLiked = true;
          Provider.of<PostData>(context, listen: false).increaseLikesCount();
        });
      }
    } else {
      setState(() {
        isLiked = true;
        Provider.of<PostData>(context, listen: false).increaseLikesCount();
      });
      _reactAnimation.animate();
      // Remember that we are passing an increased likes count over here so we dont need to increase in the Firebase file
      var isSuccessful = await storeHelper.like(post.uid, post.likesCount);
      if (!isSuccessful) {
        SharyToast.show(
            "We are having trouble connecting to the internet . Please try again later");
        setState(() {
          isLiked = false;
          Provider.of<PostData>(context, listen: false).decreaseLikesCount();
        });
      }
    }
  }

  @override
  void dispose() {
    _reactAnimation.kill();
    super.dispose();
  }
}
