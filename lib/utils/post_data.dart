import 'package:flutter/material.dart';
import 'package:shary/models/post.dart';

class PostData extends ChangeNotifier {
  Post post;
  PostData(this.post);

  void increaseLikesCount() {
    post.likesCount++;
    notifyListeners();
  }

  void decreaseLikesCount() {
    post.likesCount--;
    notifyListeners();
  }

  void setCommentsCount(int newCommentsCount) {
    post.commentsCount = newCommentsCount;
    notifyListeners();
  }
}
