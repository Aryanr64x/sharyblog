import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shary/display_picture.dart';
import 'package:shary/post_data.dart';
import 'package:shary/screens/profile_screen.dart';

class PostCardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CircleAvatar(
                minRadius: 30.0,
                child: CircularProgressIndicator(),
                backgroundImage: DisplayPicture.display(
                    Provider.of<PostData>(context).post.creatorAvatar),
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
                          return ProfileScreen(
                            userAvatar: Provider.of<PostData>(context)
                                .post
                                .creatorAvatar,
                            username:
                                Provider.of<PostData>(context).post.creatorName,
                          );
                        },
                      ));
                    },
                    child: Text(
                      Provider.of<PostData>(context).post.creatorName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  Text("2 hrs ago")
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
