import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String?> uploadAvatar(File file, User user) async {
    String? url;
    try {
      await _storage.ref('avatars/avatar${user.uid}').putFile(file);
      url = await _storage.ref('avatars/avatar${user.uid}').getDownloadURL();
    } catch (e) {
      print(e);
    }

    return url;
  }
}
