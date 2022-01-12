import 'package:flutter/material.dart';
import 'package:shary/widgets/comment_panel.dart';
import 'package:shary/widgets/react.dart';

class PostCardFooter extends StatefulWidget {
  @override
  State<PostCardFooter> createState() => _PostCardFooterState();
}

class _PostCardFooterState extends State<PostCardFooter> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(child: ReactPanel()),
          Expanded(
            child: CommentPanel(),
          )
        ],
      ),
    );
  }
}
