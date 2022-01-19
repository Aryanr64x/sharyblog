import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shary/post_data.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DisplayPicture {
  static Widget display(String? url, double radius) {
    if (url == null) {
      print("THE URL IS EMPTY");
      return Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage('images/avatar.jpg'))),
      );
    } else {
      return CachedNetworkImage(
        imageBuilder: (context, imageProvider) {
          return Container(
            height: radius,
            width: radius,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider)),
          );
        },
        imageUrl: url,
        placeholder: (context, url) {
          return Container(
            height: 40.0,
            width: 40.0,
            child: const CircularProgressIndicator(),
          );
        },
      );
    }
  }
}
