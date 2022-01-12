import 'package:flutter/material.dart';
import 'package:shary/screens/comment_screen.dart';
import 'package:provider/provider.dart';
import '../post_data.dart';

class CommentPanel extends StatefulWidget {
  @override
  State<CommentPanel> createState() => _CommentPanelState();
}

class _CommentPanelState extends State<CommentPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            var post = Provider.of<PostData>(context, listen: false).post;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => CommentScreen(
                  postId: post.uid,
                  commentsCount: post.commentsCount,
                ),
              ),
            );
          },
          icon: Icon(
            Icons.comment,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
            "${Provider.of<PostData>(context, listen: false).post.commentsCount}"),
      ],
    );
  }
}
