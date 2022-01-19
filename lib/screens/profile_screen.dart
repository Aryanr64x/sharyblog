// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shary/display_picture.dart';
import 'package:shary/firebase/firestore_helper.dart';
import 'package:shary/models/post.dart';
import 'package:shary/post_data.dart';
import 'package:shary/shary_toast.dart';
import 'package:shary/widgets/post_card_widget.dart';
import 'package:shary/widgets/profile_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  static final String id = "profile_screen";
  String username;
  String? userAvatar;

  ProfileScreen({required this.username, required this.userAvatar});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController _controller = ScrollController();
  QueryDocumentSnapshot? last_snapshot;
  bool noPost = false;
  List<Post> posts = [];
  @override
  void initState() {
    fetchPosts(true);
    _controller.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: CustomScrollView(
            controller: _controller,
            slivers: [
              ProfileAppBar(
                userAvatar: widget.userAvatar,
                username: widget.username,
              ),
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  if (index == posts.length) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [progressIndicatorOrNothing()],
                    );
                  } else {
                    return ChangeNotifierProvider<PostData>(
                      create: (context) => PostData(posts[index]),
                      child: PostCard(),
                    );
                  }
                }, childCount: posts.length + 1),
                itemExtent: 700.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  void fetchPosts(bool initial) async {
    if (initial) {
      var data = await FireStoreHelper()
          .fetchInititalPostsByUser(username: widget.username, amt: 2);
      if (data != null) {
        last_snapshot = data['last_snapshot'];

        setState(() {
          posts = data['posts'];
          if (posts.isEmpty) {
            noPost = true;
          }
        });
      } else {
        // show error for not getting the posts most prolly due to internet connection
        SharyToast.show(
            "We encountered a problem. cannot get posts anymore :(");
      }
    } else {
      var data = await FireStoreHelper().fetchNextPostsByUser(
          username: widget.username, last_snapshot: last_snapshot!, amt: 1);
      if (data != null) {
        last_snapshot = data['last_snapshot'];
        setState(() {
          posts.addAll(data['posts']);
        });
      } else {
        // show error for not getting posts most prolly due to internet connection
        SharyToast.show("Dude get your internet connection right!");
      }
    }
  }

  void listener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      fetchPosts(false);
    }
  }

  Widget progressIndicatorOrNothing() {
    if (noPost) {
      return Text("Dude has not posted even a single shit yo");
    } else {
      return CircularProgressIndicator();
    }
  }
}
