import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shary/post_data.dart';

class DisplayPicture {
  static ImageProvider display(String url) {
    if (url.isEmpty) {
      return AssetImage('images/avatar.jpg');
    } else {
      return NetworkImage(url);
    }
  }
}
