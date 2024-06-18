import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  //add properties of user
  //future me kabhi user daal rho honge to ho skta h hum kuch bhool
  //jayenge...isliye class ke form me bana lenge
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  // to json method bnaa rhee h
  //convert user obj required from the user to object
  //kuch nhi kr rhe h bs ek function bnaa rhe jo user class ka obj bnayega
  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      }; //1 liner function

//take the doc snapshot and return the UserModel
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      photoUrl: snapshot['photoUrl'],
      username: snapshot['username'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
