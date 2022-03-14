import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:shary/firebase/firestore_helper.dart';
import 'package:shary/models/post.dart';
import 'package:shary/models/shary_user.dart';
import 'package:shary/post_data.dart';
import 'package:shary/screens/new_post_screen.dart';
import 'package:shary/screens/profile_screen.dart';
import 'package:shary/screens/search_screen.dart';
import 'package:shary/screens/welcome_screen.dart';
import 'package:shary/shary_toast.dart';
import 'package:shary/utils/page_manager.dart';
import 'package:shary/widgets/appbar_profile_button.dart';
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

  bool isRefreshing = false;
  QueryDocumentSnapshot? last_snapshot;
  late final PageManager _pageManager;
  List<Post> posts = [];
  late String username;
  late String userId;
  late String? userAvatar;

  @override
  void initState() {
    username = auth.currentUser!.displayName!;
    userAvatar = auth.currentUser!.photoURL;
    userId = auth.currentUser!.uid;
    _pageManager = PageManager(onRefresh: () {
      if (!isRefreshing) {
        setState(() {
          isRefreshing = true;
        });
      }
      fetchPosts(true);
    }, onReachLast: () {
      fetchPosts(false);
    });
    fetchPosts(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const Text("Shary"),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () {
                  Navigator.pushNamed(context, SearchScreen.id);
                },
              ),
            ),
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
                },
                icon: const Icon(Icons.add),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AppbarProfileButton(
                  profileUser: SharyUser(
                      id: auth.currentUser!.uid,
                      username: auth.currentUser!.displayName!,
                      userAvatar: auth.currentUser!.photoURL)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: const Icon(Icons.power_settings_new),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popAndPushNamed(context, WelcomeScreen.id);
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            mayOrMayNotbeACircularIndicator(),
            PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _pageManager.pageController,
              itemCount: posts.length + 1,
              key: UniqueKey(),
              itemBuilder: (BuildContext context, int index) {
                if (index == posts.length) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                } else {
                  return ChangeNotifierProvider<PostData>(
                    create: (context) => PostData(posts[index]),
                    child: const PostCard(),
                  );
                }
              },
            ),
          ],
        ));
  }

  void fetchPosts(bool initial) async {
    if (initial) {
      var data = await FireStoreHelper().getFirstPosts(2);

      if (data != null) {
        setState(() {
          // Maybe the posts is filled if the functionality is called from swipe to refresh
          posts = [];
          posts = data['posts'];
        });
        // we will jump the page controller anyway be it success of failure
        last_snapshot = data['last_snapshot'];
      } else {
        SharyToast.show("Please check your internet connection...");
      }
      setState(() {
        isRefreshing = false;
      });

      // we will jump the page controller anyway be it success of failure
      _pageManager.goToFirst();
    } else {
      var data = await FireStoreHelper()
          .getNextPosts(1, last_snapshot as DocumentSnapshot);
      if (data != null) {
        setState(() {
          posts.addAll(data['posts']);
        });
        _pageManager.stayOnNewPage(posts.length);
        // As setstate takes us to the 0 page!
        last_snapshot = data['last_snapshot'];
      } else {
        // show error in getting more posts may be you are out of internet connection
        SharyToast.show("Please check your internet connection...");
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
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
