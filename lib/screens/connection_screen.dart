import 'package:flutter/material.dart';
import 'package:shary/utils/display_picture.dart';
import 'package:shary/firebase/firebase_storage_helper.dart';
import 'package:shary/firebase/firestore_helper.dart';
import 'package:shary/models/shary_user.dart';
import 'package:shary/screens/profile_screen.dart';
import 'package:shary/shary_toast.dart';

class ConnectionScreen extends StatefulWidget {
  String profileId;
  bool areFollowers;

  ConnectionScreen({required this.profileId, required this.areFollowers});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  List<SharyUser>? connections;
  final FireStoreHelper _fireStoreHelper = FireStoreHelper();
  @override
  void initState() {
    fetchConnections();
    super.initState();
  }

  void fetchConnections() async {
    late var data;
    if (widget.areFollowers) {
      data = await _fireStoreHelper.getFollowers(widget.profileId);
    } else {
      data = await _fireStoreHelper.getFollowings(widget.profileId);
    }

    if (data != null) {
      setState(() {
        connections = [];
        connections!.addAll(data);
      });
    } else {
      SharyToast.show(
          "Sorry we cannot get $connectionType() data at the moment . Please make sure you have a proper internet connection");
    }
  }

  String connectionType() {
    if (widget.areFollowers) {
      return "Followers";
    } else {
      return "Following";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: (connections == null)
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    title: Text(
                      connectionType(),
                      style: TextStyle(color: Colors.black),
                    )),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (connections!.isEmpty) {
                      return Container(
                        height: 100,
                        width: 100,
                        child: Center(
                          child: Text(
                            "The user has no ${connectionType()}  yet : /",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 75,
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return ProfileScreen(connections![index]);
                            }));
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: DisplayPicture.display(
                                      connections![index].userAvatar, 20),
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    connections![index].username,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                flex: 6,
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  childCount: (connections!.isEmpty) ? 1 : connections!.length,
                ))
              ],
            ),
    );
  }
}
