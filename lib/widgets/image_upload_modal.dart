import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageUploadModal extends StatelessWidget {
  VoidCallback onCameraTap;
  VoidCallback onGalleryTap;
  ImageUploadModal({required this.onCameraTap, required this.onGalleryTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.image,
              size: 60.0,
            ),
            color: Theme.of(context).primaryColor,
            onPressed: onGalleryTap,
          ),
          IconButton(
            icon: Icon(
              Icons.camera,
              size: 60.0,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: onCameraTap,
          )
        ],
      ),
    );
  }
}
