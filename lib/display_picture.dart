// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shary/post_data.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DisplayPicture {
  static Widget display(String? url, double radius) {
    if (url == null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage('images/avatar.jpg'),
      );
    } else {
      return CachedNetworkImage(
        imageBuilder: (context, imageProvider) {
          return CircleAvatar(
            backgroundImage: imageProvider,
            radius: radius,
          );
        },
        imageUrl: url,
        placeholder: (context, url) {
          return CircularProgressIndicator();
        },
      );
    }
  }
}
