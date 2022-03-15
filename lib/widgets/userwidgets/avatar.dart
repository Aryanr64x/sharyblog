import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar {
  static show(String url, double height, double width) {
    if (url.isEmpty) {
      return CircleAvatar(
        backgroundImage: AssetImage('assets/avatar.jpg'),
      );
    } else {
      return ClipOval(
        clipBehavior: Clip.hardEdge,
        child: CachedNetworkImage(
          imageUrl: url,
          placeholder: (BuildContext context, String str) {
            return CircularProgressIndicator();
          },
          height: height,
          width: width,
        ),
      );
    }
  }
}
