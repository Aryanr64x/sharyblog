import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shary/display_picture.dart';
import 'package:shary/firebase/firestore_helper.dart';
import 'package:shary/models/comment.dart';
import 'package:shary/models/shary_user.dart';
import 'package:shary/screens/profile_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsList extends StatefulWidget {
  String postId;
  ScrollController controller;
  CommentsList({required this.postId, required this.controller});
  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  List<Comment> comments = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(
                'Something went wrong . We cannot fetch comments right now');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          return ListView(
            controller: widget.controller,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: DisplayPicture.display(
                            data['creator_avatar'], 20.0),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return ProfileScreen(SharyUser(
                                          id: data['creator_id'],
                                          username: data['creator_name'],
                                          userAvatar: data['creator_avatar']));
                                    }));
                                  },
                                  child: Text(
                                    data['creator_name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                Text(
                                  (data['created_at'] != null)
                                      ? timeago
                                          .format(data['created_at'].toDate())
                                      : "",
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                            Text(
                              data['body'],
                            )
                          ],
                        ))
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
