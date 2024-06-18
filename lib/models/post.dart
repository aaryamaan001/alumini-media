import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  //add properties of user
  //future me kabhi user daal rho honge to ho skta h hum kuch bhool
  //jayenge...isliye class ke form me bana lenge
  final String description;
  final String uid;
  final String username;
  final String postId; //unique id
  final datePublished;
  final String postUrl;
  final String profileImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

  // to json method bnaa rhee h
  //convert user obj required from the user to object
  //kuch nhi kr rhe h bs ek function bnaa rhe jo user class ka obj bnayega
  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profileImage": profileImage,
        "likes": likes,
      }; //1 liner function

//take the doc snapshot and return the UserModel
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
    );
  }
}
