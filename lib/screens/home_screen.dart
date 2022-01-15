import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:shary/firebase/firestore_helper.dart';
import 'package:shary/models/post.dart';
import 'package:shary/post_data.dart';
import 'package:shary/screens/new_post_screen.dart';
import 'package:shary/screens/profile_screen.dart';
import 'package:shary/screens/welcome_screen.dart';
import 'package:shary/widgets/home_app_bar.dart';
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
  bool isRefreshing = false;
  QueryDocumentSnapshot? last_snapshot;
  List<Post> posts = [];
  final double REFRESH_OFFEST = -70.8899663140498;

  @override
  void initState() {
    super.initState();
    fetchPosts(true);
    _pageController.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HomeAppBar(
          onNewPostAdded: (Post newPost) {
            setState(() {
              posts.insert(0, newPost);
            });
            _pageController.jumpTo(0);
          },
        ) as AppBar,
        body: Stack(
          children: [
            mayOrMayNotbeACircularIndicator(),
            PageView.builder(
              physics: BouncingScrollPhysics(),
              controller: _pageController,
              itemCount: posts.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == posts.length) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ChangeNotifierProvider<PostData>(
                    create: (context) => PostData(posts[index]),
                    child: PostCard(),
                  );
                }
              },
            ),
          ],
        ));
  }

  void listener() {
    // check we have reached the last page which is actually the loading page .....
    if (_pageController.position.pixels ==
        _pageController.position.maxScrollExtent) {
      print(
          "We have reached the max scroll extent now go and fetch more posts");

      fetchPosts(false);
    } else if (_pageController.position.pixels < REFRESH_OFFEST) {
      if (!isRefreshing) {
        print("Its time to refresh");
        setState(() {
          isRefreshing = true;
        });
        posts = [];
        fetchPosts(true);
      }
    }
    print(_pageController.position.axis.index);
    print(_pageController.position.pixels);
  }

  void fetchPosts(bool initial) async {
    if (initial) {
      var data = await FireStoreHelper().getFirstPosts(2);
      // we will jump the page controller anyway be it success of failure
      _pageController.jumpTo(0);
      if (data != null) {
        setState(() {
          posts = data['posts'];
        });
        last_snapshot = data['last_snapshot'];
      } else {
        // display error in fetching posts
      }
    } else {
      var data = await FireStoreHelper()
          .getNextPosts(1, last_snapshot as DocumentSnapshot);
      if (data != null) {
        isRefreshing = false;
        setState(() {
          posts.addAll(data['posts']);
        });
        last_snapshot = data['last_snapshot'];
      } else {
        // show error in getting more posts may be you are out of internet connection
      }
    }
  }

  Widget mayOrMayNotbeACircularIndicator() {
    if (isRefreshing) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 30.0),
            child: CircularProgressIndicator(),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
