import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shary/models/comment.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shary/models/post.dart';

class FireStoreHelper {
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getFirstPosts(int amt) async {
    try {
      List<Post> posts = [];
      QuerySnapshot data = await _store
          .collection('posts')
          .orderBy('created_at', descending: true)
          .limit(2)
          .get();

      for (var post in data.docs) {
        posts.add(Post(
            uid: post.id,
            title: post['title'],
            body: post['body'],
            createdAt: timeago.format(post['created_at'].toDate()),
            likesCount: post['likes_count'],
            commentsCount: post['comments_count'],
            creatorName: post['creator_name'],
            creatorId: post['creator_id'],
            creatorAvatar: post['creator_avatar']));
      }
      return {
        'posts': posts,
        'last_snapshot': data.docs.last,
      };
    } catch (e) {
      print("AND HERE GOES THE GODDAM ERROR");
      print(e);
    }
  }

  Future<Map<String, dynamic>?> getNextPosts(
      int amt, DocumentSnapshot last_snapshot) async {
    try {
      List<Post> posts = [];
      QuerySnapshot data = await _store
          .collection('posts')
          .orderBy('created_at')
          .startAfterDocument(last_snapshot as DocumentSnapshot)
          .limit(1)
          .get();
      for (var post in data.docs) {
        posts.add(Post(
            uid: post.id,
            title: post['title'],
            body: post['body'],
            createdAt: timeago.format(post['created_at'].toDate()),
            likesCount: post['likes_count'],
            commentsCount: post['comments_count'],
            creatorId: post['creator_id'],
            creatorName: post['creator_name'],
            creatorAvatar: post['creator_avatar']));
      }
      return {
        'posts': posts,
        'last_snapshot': data.docs.last,
      };
    } catch (e) {
      print("AND HERE GOES THE GODDAM ERROR");
      print(e);
    }
  }

  Future<Post?> createPost({
    required String title,
    required String body,
  }) async {
    try {
      var data = await _store.collection('posts').add({
        'title': title,
        'body': body,
        'likes_count': 0,
        'comments_count': 0,
        'created_at': FieldValue.serverTimestamp(),
        'creator_name': auth.currentUser!.displayName,
        'creator_avatar': auth.currentUser!.photoURL,
        'creator_id': auth.currentUser!.uid
      });

      return Post(
          uid: data.id,
          title: title,
          createdAt: "Just now",
          body: body,
          creatorName: auth.currentUser!.displayName!,
          creatorAvatar: auth.currentUser!.displayName!,
          creatorId: auth.currentUser!.uid,
          likesCount: 0,
          commentsCount: 0);
    } catch (e) {
      print("AND HERE GOES THE GODDAM ERROR");
      print(e);
    }
  }

  Future<bool?> isLiked(String postId) async {
    try {
      var data = await _store
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .where('username', isEqualTo: auth.currentUser!.displayName)
          .get();
      if (data.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> like(String postId, int likesCount) async {
    try {
      var docref = _store.collection('posts').doc(postId);
      await docref
          .collection('likes')
          .add({'username': auth.currentUser!.displayName});

      await docref.update({'likes_count': likesCount + 1});

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> dislike(String postId, int likesCount) async {
    try {
      var docRef = _store.collection('posts').doc(postId);
      var collections = await docRef
          .collection('likes')
          .where('username', isEqualTo: auth.currentUser!.displayName)
          .get();
      for (var data in collections.docs) {
        await data.reference.delete();
      }
      await docRef.update({'likes_count': likesCount--});

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Comment?> addComment(
      String postId, String body, int commentsCount) async {
    try {
      var docref = _store.collection('posts').doc(postId);
      var commentref = await docref.collection('comments').add({
        'body': body,
        'creator_name': auth.currentUser!.displayName,
        'creator_avatar': auth.currentUser!.photoURL,
        'created_at': FieldValue.serverTimestamp()
      });
      await docref.update({'comments_count': commentsCount + 1});
      print("The update is successful");
      return Comment(
          uid: commentref.id,
          body: body,
          creatorName: auth.currentUser!.displayName!,
          creatorAvatar: auth.currentUser!.photoURL!);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Comment>?> fetchComments(String postId) async {
    List<Comment> comments = [];
    try {
      var queries = await _store
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      for (var comment_data in queries.docs) {
        comments.add(
          Comment(
            uid: comment_data.id,
            body: comment_data['body'],
            creatorName: comment_data['creator_name'],
            creatorAvatar: comment_data['creator_avatar'],
          ),
        );
      }
      return comments;
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> fetchInititalPostsByUser(
      {required String userId, required int amt}) async {
    List<Post> posts = [];
    try {
      var queries = await _store
          .collection('posts')
          .where('creator_id', isEqualTo: userId)
          .orderBy('created_at')
          .limit(amt)
          .get();

      for (var post in queries.docs) {
        posts.add(
          Post(
              uid: post.id,
              createdAt: timeago.format(post['created_at'].toDate()),
              title: post['title'],
              body: post['body'],
              likesCount: post['likes_count'],
              commentsCount: post['comments_count'],
              creatorName: post['creator_name'],
              creatorId: post['creator_id'],
              creatorAvatar: post['creator_avatar']),
        );
      }

      print("HERE GOES WHAT YOU ARE TRYING TO SEE");

      return {
        'posts': posts,
        'last_snapshot': (queries.docs.isEmpty) ? null : queries.docs.last,
      };
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> fetchNextPostsByUser(
      {required String userId,
      required DocumentSnapshot last_snapshot,
      required int amt}) async {
    List<Post> posts = [];
    try {
      var queries = await _store
          .collection('posts')
          .where('creator_id', isEqualTo: userId)
          .orderBy('created_at')
          .startAfterDocument(last_snapshot)
          .limit(amt)
          .get();

      for (var post in queries.docs) {
        posts.add(
          Post(
              createdAt: timeago.format(post['created_at'].toDate()),
              uid: post.id,
              title: post['title'],
              body: post['body'],
              likesCount: post['likes_count'],
              commentsCount: post['comments_count'],
              creatorName: post['creator_name'],
              creatorId: post['creator_id'],
              creatorAvatar: post['creator_avatar']),
        );
      }
      return {
        'posts': posts,
        'last_snapshot': queries.docs.last,
      };
    } catch (e) {
      print(e);
    }
  }
}
