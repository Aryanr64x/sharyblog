import 'package:flutter/material.dart';

class ImageUploadModal extends StatelessWidget {
  void Function() onGalleryTap;
  void Function() onCameraTap;
  ImageUploadModal({required this.onGalleryTap, required this.onCameraTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(2),
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "What do you want to create?",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                      onPressed: onCameraTap,
                      child: Text(
                        "Camera",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_library_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                      onPressed: onGalleryTap,
                      child: Text(
                        "Gallery",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
