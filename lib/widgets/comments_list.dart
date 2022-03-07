import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shary/display_picture.dart';
import 'package:shary/firebase/firestore_helper.dart';
import 'package:shary/models/comment.dart';

class CommentsList extends StatefulWidget {
  String postId;

  CommentsList({required this.postId});
  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  List<Comment> comments = [];

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
            .orderBy(
              "created_at",
            )
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
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                leading: DisplayPicture.display(data['creator_avatar'], 20.0),
                title: Text(data['creator_name']),
                subtitle: Text(data['body']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
