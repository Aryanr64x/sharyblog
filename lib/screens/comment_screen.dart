import 'package:flutter/material.dart';
import 'package:shary/dialog.dart';
import 'package:shary/firebase/firestore_helper.dart';
import 'package:shary/widgets/comments_list.dart';
import 'package:shary/widgets/primary_button_widget.dart';

// since validation is also negligible and only one field is there we will use Textfield without form
class CommentScreen extends StatelessWidget {
  String postId;
  int commentsCount;
  CommentScreen({required this.postId, required this.commentsCount});

  static const String id = 'comment_screen';
  String? comment;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: CommentsList(
                postId: postId,
              ),
              flex: 8,
            ),
            Expanded(
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (String? value) {
                          comment = value;
                        },
                        decoration:
                            InputDecoration(hintText: "Enter your comment!"),
                      ),
                      flex: 6,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.resolveWith(
                                  (states) => CircleBorder()),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) =>
                                      Theme.of(context).primaryColor)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(Icons.comment),
                          ),
                          onPressed: () async {
                            if (comment != null && comment != '') {
                              var newComment = await FireStoreHelper()
                                  .addComment(postId, comment!, commentsCount);
                              if (newComment != null) {
                                commentsCount++;
                                print("new comment has been created");
                              } else {
                                SharyDialog.show(
                                    "Sorry we cannot create  a comment now.. try again later !");
                              }
                            }
                          },
                        ),
                      ),
                      flex: 2,
                    )
                  ],
                ),
              ),
              flex: 1,
            )
          ],
        ),
      ),
    ));
  }
}
