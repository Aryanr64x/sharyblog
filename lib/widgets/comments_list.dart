import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    print(widget.postId);
    fetchComments();
  }

  void fetchComments() async {
    var data = await FireStoreHelper().fetchComments(widget.postId);
    if (data != null) {
      setState(() {
        comments = data;
        isLoading = false;
      });
    } else {
      print("show error in fetching the comment");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? Text("Loading")
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .orderBy(
                    "created_at",
                  )
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                      'Something went wrong . We cannot fetch comments right now');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(data['creator_avatar']),
                      ),
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
