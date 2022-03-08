import 'package:flutter/material.dart';
import 'package:shary/models/post.dart';
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
    Post post = Provider.of<PostData>(context, listen: false).post;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            _openCommentsScreen(post, context);
          },
          icon: Icon(
            Icons.comment,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(post.commentsCount.toString()),
      ],
    );
  }

  _openCommentsScreen(Post post, BuildContext context) async {
    int newCommentsCount = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CommentScreen(
          postId: post.uid,
          commentsCount: post.commentsCount,
        ),
      ),
    );

    setState(() {
      Provider.of<PostData>(context, listen: false)
          .setCommentsCount(newCommentsCount);
    });
  }
}
