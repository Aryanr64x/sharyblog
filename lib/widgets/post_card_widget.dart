import 'package:flutter/material.dart';
import 'package:shary/models/post.dart';
import 'package:shary/widgets/post_card_header.dart';
import 'package:shary/widgets/post_card_body.dart';
import 'package:shary/widgets/post_card_footer.dart';

class PostCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 500.0,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        elevation: 40.0,
        child: Column(
          children: [
            PostCardHeader(),
            PostCardBody(),
            PostCardFooter(),
          ],
        ),
      ),
    );
  }
}
