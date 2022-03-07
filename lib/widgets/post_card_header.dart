import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shary/display_picture.dart';
import 'package:shary/models/post.dart';
import 'package:shary/models/shary_user.dart';
import 'package:shary/post_data.dart';
import 'package:shary/screens/profile_screen.dart';
import 'package:shary/widgets/avatar.dart';

class PostCardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Post post = Provider.of<PostData>(context).post;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: DisplayPicture.display(post.creatorAvatar, 50.0),
              ),
              flex: 2,
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext contexted) {
                          return ProfileScreen(SharyUser(
                              id: post.creatorId,
                              username: post.creatorName,
                              userAvatar: post.creatorAvatar));
                        },
                      ));
                    },
                    child: Text(
                      post.creatorName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  Text(post.createdAt)
                ],
              ),
              flex: 8,
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {},
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
