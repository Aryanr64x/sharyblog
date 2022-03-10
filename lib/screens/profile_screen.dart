// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shary/display_picture.dart';
import 'package:shary/firebase/firestore_helper.dart';
import 'package:shary/models/post.dart';
import 'package:shary/models/profile.dart';
import 'package:shary/models/shary_user.dart';
import 'package:shary/post_data.dart';
import 'package:shary/shary_toast.dart';
import 'package:shary/widgets/post_card_widget.dart';
import 'package:shary/widgets/profile_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  static final String id = "profile_screen";
  SharyUser profileUser;

  ProfileScreen(this.profileUser);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController _controller = ScrollController();
  QueryDocumentSnapshot? last_snapshot;
  bool postsLoaded = false;
  List<Post> posts = [];
  Profile? profile;
  bool? isFollowing;
  final FireStoreHelper _storeHelper = FireStoreHelper();

  @override
  void initState() {
    fetchPosts(true);
    fetchProfile();
    _controller.addListener(listener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: (profile != null && postsLoaded && isFollowing != null)
            ? CustomScrollView(
                controller: _controller,
                slivers: [
                  ProfileAppBar(
                      profile: profile!,
                      profileUser: widget.profileUser,
                      isFollowing: isFollowing!),
                  SliverFixedExtentList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      if (index == posts.length) {
                        return Center(
                          child: _indicatorOrText(),
                        );
                      } else {
                        return ChangeNotifierProvider<PostData>(
                          create: (context) => PostData(posts[index]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: PostCard(),
                          ),
                        );
                      }
                    }, childCount: posts.length + 1),
                    itemExtent: 700.0,
                  )
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
      ),
    );
  }

  void fetchProfile() async {
    var data = await _storeHelper.fetchProfile(widget.profileUser.id);
    if (data != null) {
      setState(() {
        profile = data;
      });
      // Call only after profile is loaded successfully
      fetchFollowStatus();
    } else {
      SharyToast.show("Oops SOMETHING went wrong . please try again later");
    }
  }

  void fetchPosts(bool initial) async {
    if (initial) {
      var data = await _storeHelper.fetchInititalPostsByUser(
          userId: widget.profileUser.id, amt: 2);
      if (data != null) {
        last_snapshot = data['last_snapshot'];

        setState(() {
          posts = data['posts'];
          postsLoaded = true;
        });
      } else {
        // show error for not getting the posts most prolly due to internet connection
        SharyToast.show(
            "We encountered a problem. cannot get posts anymore :(");
      }
    } else {
      var data = await _storeHelper.fetchNextPostsByUser(
          userId: widget.profileUser.id, last_snapshot: last_snapshot!, amt: 1);
      if (data != null) {
        last_snapshot = data['last_snapshot'];
        setState(() {
          posts.addAll(data['posts']);
        });
      } else {
        // show error for not getting posts most prolly due to internet connection
        SharyToast.show(
            "Either your internet is down or there are no posts to show anymore");
      }
    }
  }

  fetchFollowStatus() async {
    bool? followStatus = await _storeHelper.isFollowing(profile!.profileId);
    if (followStatus != null) {
      setState(() {
        isFollowing = followStatus;
      });
    }
    // No writing else for this .error will be shown by other widgets on internet failure!!!!
  }

  void listener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      fetchPosts(false);
    }
  }

  Widget _indicatorOrText() {
    if (posts.isEmpty) {
      return Text("Dude has no posts yet!");
    } else {
      return CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
      );
    }
  }
}
