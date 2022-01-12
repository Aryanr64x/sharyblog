import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shary/dialog.dart';
import 'package:shary/error.dart';
import 'package:shary/firebase/firestore_helper.dart';
import 'package:shary/models/post.dart';
import 'package:shary/widgets/primary_button_widget.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class NewPostScreen extends StatelessWidget {
  static final String id = 'new_post';

  String? _title;
  String? _body;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please , you have to enter a title";
                      }
                    },
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
                    decoration: InputDecoration(
                        hintText: "Enter a catchy title",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none),
                    onChanged: (String value) {
                      _title = value;
                    },
                  ),
                  HtmlEditor(
                    callbacks: Callbacks(onChangeContent: (value) {
                      print(value);
                      _body = value;
                    }),
                    controller: HtmlEditorController(), //required
                    htmlEditorOptions: HtmlEditorOptions(
                      hint: "Your text here. n  ..",
                      //initalText: "text content initial, if any",
                    ),
                    otherOptions: OtherOptions(
                      height: 400,
                    ),
                  ),
                  AppPrimaryButton(
                      title: "Create",
                      onTap: () async {
                        if (_formkey.currentState!.validate()) {
                          showLoaderDialog(context);
                          Post? post = await FireStoreHelper().createPost(
                            title: _title!,
                            body: _body!,
                          );
                          if (post != null) {
                            Navigator.pop(context);
                            Navigator.pop(context, post);
                          } else {
                            Navigator.pop(context);

                            SharyDialog.show(
                                "Sorry we could not create the post at this time, Try again later");
                          }
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SharyDialog.show("Creating a new post");
      },
    );
  }
}
