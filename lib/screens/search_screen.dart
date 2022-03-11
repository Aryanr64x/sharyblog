// ignore_for_file: prefer_const_constructors

import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:shary/algolia/shary_algolia.dart';
import 'package:shary/display_picture.dart';
import 'package:shary/models/shary_user.dart';
import 'package:shary/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  static final String id = "search";

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Algolia algolia = SharyAlgolia.client;
  bool fetchingUsers = false;
  List<SharyUser>? users;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          children: [
            TextField(
              onChanged: (value) async {
                setState(() {
                  fetchingUsers = true;
                });
                var res =
                    await algolia.index('users').query(value).getObjects();
                setState(() {
                  fetchingUsers = false;
                  users = [];
                  for (var data in res.hits) {
                    users!.add(SharyUser(
                        id: data.data['objectID'],
                        username: data.data['username'],
                        userAvatar: data.data['userAvatar']));
                  }
                });
              },
              decoration: InputDecoration(
                hintText: "Search an user.....",
              ),
            ),

            (fetchingUsers)
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : (users != null && users!.isNotEmpty)
                    ? ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 75,
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return ProfileScreen(users![index]);
                                }));
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: DisplayPicture.display(
                                          users![index].userAvatar, 20),
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        users![index].username,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 6,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        shrinkWrap: true,
                        itemCount: users!.length,
                      )
                    : (users != null && users!.isEmpty)
                        ? Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text("No user matches your query"))
                        : Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Text("Search results go here"))

            // ListView();
          ],
        ),
      ),
    ));
  }
}
