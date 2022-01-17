import 'package:flutter/material.dart';
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

class _ReactPanelState extends State<ReactPanel> {
  bool isLoading = true;
  bool? isLiked;
  String get myname => widget.name;
  final FireStoreHelper storeHelper = FireStoreHelper();

  @override
  void initState() {
    super.initState();

    checkIsLiked();
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
            setState(() {
              isLoading = true;
            });
            likeOrUnlike();
          },
          icon: Icon(Icons.thumb_down),
          color: Theme.of(context).primaryColor,
        );
      } else {
        return IconButton(
          onPressed: () {
            setState(() {
              isLoading = true;
            });

            likeOrUnlike();
          },
          icon: Icon(Icons.thumb_up),
          color: Theme.of(context).primaryColor,
        );
      }
    }
  }

  void likeOrUnlike() async {
    if (isLiked!) {
      var isSuccessful = await storeHelper.dislike(
          Provider.of<PostData>(context, listen: false).post.uid,
          Provider.of<PostData>(context, listen: false).post.likesCount);
      isLoading = false;
      if (isSuccessful) {
        setState(() {
          isLiked = false;
        });
        Provider.of<PostData>(context, listen: false).decreaseLikesCount();
      } else {
        SharyToast.show(
            "We cannot complete that action currently . Please check your internet connection and try again");
      }
    } else {
      var isSuccessful = await storeHelper.like(
          Provider.of<PostData>(context, listen: false).post.uid,
          Provider.of<PostData>(context, listen: false).post.likesCount);
      isLoading = false;
      if (isSuccessful) {
        setState(() {
          isLiked = true;
        });
        Provider.of<PostData>(context, listen: false).increaseLikesCount();
      } else {
        SharyToast.show(
            "We are having trouble connecting to the internet . Please try again later");
      }
    }
  }
}
