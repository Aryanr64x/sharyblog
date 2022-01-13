// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shary/firebase/firestore_helper.dart';
import 'package:shary/models/post.dart';
import 'package:shary/post_data.dart';
import 'package:shary/widgets/post_card_widget.dart';
import 'package:shary/widgets/profile_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  static final String id = "profile_screen";
  String username;
  String userAvatar;
  ProfileScreen({required this.username, required this.userAvatar});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Post> posts = [];
  @override
  void initState() {
     fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: CustomScrollView(
            slivers: [
              ProfileAppBar(username: widget.username, userAvatar: widget.userAvatar),
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return ChangeNotifierProvider<PostData>(
                    create: (context) => PostData(posts[index]),
                    child: PostCard(),
                  );

                }, childCount: posts.length),
                itemExtent: 700.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  void fetchPosts() async {
    var posts_data = await FireStoreHelper().fetchPostByUser(widget.username);
    if (posts_data == null) {
      print("show error");
    } else {
      print(posts_data);
      setState(() {
        posts.addAll(posts_data);
      });
    }
  }
}
