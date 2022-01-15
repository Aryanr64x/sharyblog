import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shary/post_data.dart';

class PostCardBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("SOME SHIT HAS BEEN PRINBTED FROM HEREE");
    return Expanded(
      flex: 8,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            Expanded(
              child: Container(
                child: Text(
                  Provider.of<PostData>(context).post.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Container(
                child: Html(
                  data: Provider.of<PostData>(context).post.body,
                ),
              ),
              flex: 8,
            ),
          ],
        ),
      ),
    );
  }
}
