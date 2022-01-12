import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shary/models/post.dart';
import 'package:shary/post_data.dart';
import 'package:shary/screens/new_post_screen.dart';
import 'package:shary/screens/welcome_screen.dart';
import 'package:shary/widgets/post_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  static const String id = 'home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;
  final _pageController = PageController();
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  void fetchPosts() async {
    var data = await store.collection('posts').get();
    setState(() {
      for (var post_data in data.docs) {
        posts.add(
          Post(
              uid: post_data.id,
              title: post_data['title'],
              body: post_data['body'],
              creatorName: post_data['creator_name'],
              creatorAvatar: post_data['creator_avatar'],
              likesCount: post_data['likes_count'],
              commentsCount: post_data['comments_count']),
        );
      }
    });

    print(posts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Shary"),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                onPressed: () async {
                  var data =
                      await Navigator.pushNamed(context, NewPostScreen.id);

                  Post newPost = data as Post;

                  setState(() {
                    posts.insert(0, newPost);
                  });
                  _pageController.jumpTo(0);
                },
                icon: Icon(Icons.add),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.account_circle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.power_settings_new),
                onPressed: () async {
                  try {
                    await auth.signOut();
                    Navigator.popAndPushNamed(context, WelcomeScreen.id);
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ),
          ],
        ),
        body: PageView.builder(
            physics: BouncingScrollPhysics(),
            controller: _pageController,
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              return ChangeNotifierProvider<PostData>(
                create: (context) => PostData(posts[index]),
                child: PostCard(),
              );
            }));
  }
}
