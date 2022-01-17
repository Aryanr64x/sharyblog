import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shary/error.dart';
import 'package:shary/firebase/firebase_storage_helper.dart';
import 'package:shary/screens/home_screen.dart';
import 'package:shary/shary_toast.dart';
import 'package:shary/widgets/primary_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shary/widgets/image_upload_modal.dart';
import 'package:shary/constants.dart';

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
        onPressed: () async {
          if (username != null && username != '') {
            print("This part has been reached");
            try {
              await auth.currentUser!.updateDisplayName(username);
              await _uploadAvatar();
              Navigator.popAndPushNamed(context, HomeScreen.id);
            } catch (e) {
              print(e);
              SharyToast.show(
                  "We are having problem updating your profile info. Please check your internet connection");
            }
          } else {
            SharyToast.show(
                "Please enter a username atleast to continue with :)");
          }

          print("tHIS PART HAS ALSO BEEN REACHED");
        },
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
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Please provide an username",
                  ),
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

  void _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    file = File(image!.path);
    setState(() {
      imageWidget = Image.file(file!);
      // imageWidget = Image.memory(bytes);
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
    if (file != null) {
      String? url = await storageHelper.uploadAvatar(file!, auth.currentUser!);
      if (url != null) {
        try {
          await auth.currentUser!.updatePhotoURL(url);
        } catch (e) {
          print(e);
          SharyToast.show(
              "Sorry , We are having problem uploading picture at the moment !");
        }
      }
    } else {
      try {
        await auth.currentUser!.updatePhotoURL('');
      } catch (e) {
        print(e);
      }
    }
  }
}
