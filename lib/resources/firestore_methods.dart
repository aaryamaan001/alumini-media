import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  //initialize firebasefirestore

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //function to upload the post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = "some error occured";

    try {
      //pehle image ko upload krna padega in the firebaseStorage->download link
      // uss url ko firestore database me store krna h
      String photoUrl =
          await StorageMethods().uploadImagaeToStorage('posts', file, true);
      // ab photo bhi url me convert ho gya h

      //uuid package to add unique identifier
      // v1 b n v4 2 fun h -> v1 will make id based on time
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId, //uid use nhi kr skte..1user many post
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );

      //firestore me add ho gya h
      //ab database me add kr rhe h
      _firestore.collection('posts').doc(postId).set(post
          .toJson()); //post cant be passed directly so we need to convert it into map

      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  //isme like ko save update kr rhe
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        //dislike
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "error";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = "success";
      } else {
        res = "text is empty";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //deleting post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .delete(); //collection ko delete krna nhi hota h
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        //remove
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {}
  }
}
