import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shary/models/comment.dart';
import 'package:shary/models/profile.dart';
import 'package:shary/models/shary_user.dart';
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
    String authUserId = auth.currentUser!.uid;
    String authUsername = auth.currentUser!.displayName!;
    String? authUserAvatar = auth.currentUser!.photoURL!;
    try {
      var docref = _store.collection('posts').doc(postId);
      var commentref = await docref.collection('comments').add({
        'body': body,
        'creator_id': auth.currentUser!.uid,
        'creator_name': auth.currentUser!.displayName,
        'creator_avatar': auth.currentUser!.photoURL,
        'created_at': FieldValue.serverTimestamp()
      });
      await docref.update({'comments_count': commentsCount + 1});
      print("The update is successful");
      return Comment(
        createdAt: 'Just now',
        uid: commentref.id,
        body: body,
        creator: SharyUser(
            id: authUserId, userAvatar: authUserAvatar, username: authUsername),
      );
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
      print("HERE GOES THE ERROR");
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

  // Profile related requests
  Future<void> createProfile(String userId) async {
    await _store.collection('profiles').add({
      'user_id': userId,
      'followers_count': 0,
      'followings_count': 0,
      'posts_count': 0
    });
  }

  Future<Profile?> fetchProfile(String userId) async {
    try {
      var querySnap = await _store
          .collection('profiles')
          .where('user_id', isEqualTo: userId)
          .get();
      var docQuerySnap = querySnap.docs.last;

      return Profile(
          profileId: docQuerySnap.id,
          followersCount: docQuerySnap['followers_count'],
          followingsCount: docQuerySnap['followings_count'],
          postsCount: docQuerySnap['posts_count']);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> follow(String followed_id, String followed_username,
      String? followed_avatar) async {
    print("THE CODE HAS BEEN PRINTED BELOW");
    print(followed_id);
    try {
      var collRef = _store.collection('profiles');
      var data = await collRef.where('user_id', isEqualTo: followed_id).get();
      await collRef.doc(data.docs.last.id).update(
        {
          'followers_count': data.docs.last['followers_count'] + 1,
        },
      );
      await collRef.doc(data.docs.last.id).collection('followers').add({
        'user_id': auth.currentUser!.uid,
        'username': auth.currentUser!.displayName,
        'avatar': auth.currentUser!.photoURL
      });

      var data2 = await collRef
          .where('user_id', isEqualTo: auth.currentUser!.uid)
          .get();

      await collRef.doc(data2.docs.last.id).update(
        {
          'followings_count': data2.docs.last['followings_count'] + 1,
        },
      );
      await collRef.doc(data2.docs.last.id).collection('followings').add({
        'user_id': followed_id,
        'username': followed_username,
        'avatar': followed_avatar
      });

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> unfollow(String followed_id, String followed_username,
      String? followed_avatar) async {
    try {
      var collRef = _store.collection('profiles');
      var data = await collRef.where('user_id', isEqualTo: followed_id).get();
      var followerRef = collRef.doc(data.docs.last.id).collection('followers');
      var follower = await followerRef
          .where('user_id', isEqualTo: auth.currentUser!.uid)
          .get();
      await followerRef.doc(follower.docs.last.id).delete();
      await collRef.doc(data.docs.last.id).update(
        {
          'followers_count': data.docs.last['followers_count'] - 1,
        },
      );

      var data2 = await collRef
          .where('user_id', isEqualTo: auth.currentUser!.uid)
          .get();
      var followingRef =
          collRef.doc(data2.docs.last.id).collection('followings');
      var following =
          await followingRef.where('user_id', isEqualTo: followed_id).get();
      await followingRef.doc(following.docs.last.id).delete();
      await collRef.doc(data2.docs.last.id).update(
        {
          'followings_count': data2.docs.last['followings_count'] - 1,
        },
      );

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool?> isFollowing(String profileId) async {
    try {
      var querySnap = await _store
          .collection('profiles')
          .doc(profileId)
          .collection('followers')
          .where('user_id', isEqualTo: auth.currentUser!.uid)
          .get();

      if (querySnap.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  // Grab all the followers of the given user id
  Future<List<SharyUser>?> getFollowers(String profileId) async {
    try {
      List<SharyUser> followers = [];
      var data = await _store
          .collection('profiles')
          .doc(profileId)
          .collection('followers')
          .get();

      for (var follower in data.docs) {
        followers.add(SharyUser(
            id: follower['user_id'],
            username: follower['username'],
            userAvatar: follower['avatar']));
      }
      return followers;
    } catch (e) {
      print(e);
    }
  }

  // Grab all the followings of the  user
  Future<List<SharyUser>?> getFollowings(String profileId) async {
    try {
      List<SharyUser> followings = [];
      var data = await _store
          .collection('profiles')
          .doc(profileId)
          .collection('followings')
          .get();
      for (var following in data.docs) {
        followings.add(
          SharyUser(
            id: following['user_id'],
            username: following['username'],
            userAvatar: following['avatar'],
          ),
        );
      }
      return followings;
    } catch (e) {
      print(e);
    }
  }
}
