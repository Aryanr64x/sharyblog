// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shary/firebase/firestore_helper.dart';
import 'package:shary/models/post.dart';
import 'package:shary/post_data.dart';
import 'package:shary/widgets/post_card_widget.dart';

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
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 249.0,
                stretch: true,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: [StretchMode.fadeTitle],
                  background: Column(
                    children: [
                      CircleAvatar(
                        radius: 75.0,
                        backgroundImage: Image.network(
                                "https://upload.wikimedia.org/wikipedia/en/c/c6/Jesse_Pinkman_S5B.png")
                            .image,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            "Jessie Pinkman",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: const [
                          Expanded(
                            child: Center(
                              child: Text(
                                "21 posts",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Center(
                            child: Text(
                              "789 followers",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                          Expanded(
                            child: Center(
                              child: Text(
                                "75 follows",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
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
