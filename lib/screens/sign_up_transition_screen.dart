import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shary/dialog.dart';
import 'package:shary/error.dart';
import 'package:shary/firebase/firebase_storage_helper.dart';
import 'package:shary/screens/home_screen.dart';
import 'package:shary/shary_toast.dart';
import 'package:shary/utils/field_type.dart';
import 'package:shary/widgets/primary_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shary/widgets/image_upload_modal.dart';
import 'package:shary/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shary/widgets/shary_input.dart';

class SignUpTransitionScreen extends StatefulWidget {
  static final String id = 'sign_up_transition';
  const SignUpTransitionScreen({Key? key}) : super(key: key);

  @override
  _SignUpTransitionScreenState createState() => _SignUpTransitionScreenState();
}

class _SignUpTransitionScreenState extends State<SignUpTransitionScreen> {
  String? username;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorageHelper storageHelper = FirebaseStorageHelper();
  final ImagePicker _picker = ImagePicker();
  File? file;

  Image imageWidget = Image.asset("images/avatar.jpg");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: handleActionpress,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.arrow_forward),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Finish setting up your account!",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 70.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage: imageWidget.image,
                    ),
                    SizedBox(
                      height: 10.0,
                      width: double.infinity,
                    ),
                    AppPrimaryButton(
                        title: "Upload Image",
                        onTap: () {
                          _showImagePicker();
                        }),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                SharyInput(
                  fieldType: FieldType.PLAIN_TEXT,
                  validators: (value) {},
                  hintText: "Enter an username for yourself...",
                  maxLines: 1,
                  onChanged: (value) {
                    username = value;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleActionpress() async {
    if (username != null && username != '') {
      showLoadingDialog(context);
      try {
        await auth.currentUser!.updateDisplayName(username);
        // The below method has a nested try catch

      } catch (e) {
        _closeDialogAndShowError();
        print(e);
      }
      if (file != null) {
        await _uploadAvatar();
      }
      var response = await http.post(
        Uri.parse(
            'https://67ff-2405-201-a409-c198-a97f-1972-1196-6a05.ngrok.io'),
        body: json.encode({
          'username': username,
          'user_avatar': auth.currentUser!.photoURL,
          'id': auth.currentUser!.uid
        }),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.popAndPushNamed(context, HomeScreen.id);
      } else {
        _closeDialogAndShowError();
      }
    } else {
      SharyToast.show("Please enter a username atleast to continue with :)");
    }
  }

  void _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    file = File(image!.path);
    setState(() {
      imageWidget = Image.file(file!);
    });
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImageUploadModal(
          onGalleryTap: () {
            _pickImage(ImageSource.gallery);
          },
          onCameraTap: () {
            _pickImage(ImageSource.camera);
          },
        );
      },
    );
  }

  Future<void> _uploadAvatar() async {
    String? url = await storageHelper.uploadAvatar(file!, auth.currentUser!);
    if (url != null) {
      try {
        await auth.currentUser!.updatePhotoURL(url);
      } catch (e) {
        _closeDialogAndShowError();

        print(e);
      }
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SharyDialog.show("Hangup a moment!", context);
      },
    );
  }

  void _closeDialogAndShowError() {
    Navigator.of(context, rootNavigator: true).pop();
    SharyToast.show("Oops Something went wrong !. Please try again later");
  }
}
