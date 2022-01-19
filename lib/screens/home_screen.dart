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
import 'package:shary/shary_toast.dart';
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
  late String username;
  late String? userAvatar;

  @override
  void initState() {
    // super.initState();
    username = auth.currentUser!.displayName!;
    userAvatar = auth.currentUser!.photoURL;

    if (auth.currentUser!.photoURL == null) {
      print("BITCH THE PHOTO URL IS NULL");
    } else {
      print("BITCH THE PHOTO URL IS NOT NULL");
    }
    fetchPosts(true);
    _pageController.addListener(listener);
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
                    posts.add(newPost);
                  });
                },
                icon: Icon(Icons.add),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return ProfileScreen(
                      userAvatar: userAvatar,
                      username: username,
                    );
                  }));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.power_settings_new),
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

        fetchPosts(true);
      }
    }
    print(_pageController.position.axis.index);
    print(_pageController.position.pixels);
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
      _pageController.jumpTo(0);
    } else {
      var data = await FireStoreHelper()
          .getNextPosts(1, last_snapshot as DocumentSnapshot);
      if (data != null) {
        setState(() {
          posts.addAll(data['posts']);
        });
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
            child: CircularProgressIndicator(),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}


// HomeAppBar(
//           username: username,
//           avatar: userAvatar,
//           context: context,
//           onNewPostAdded: (Post newPost) {
//             setState(() {
//               posts.insert(0, newPost);
//             });
//             _pageController.jumpTo(0);
//           },
//         ) as AppBar