import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/user.dart' as model;
import 'package:social_media_app/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //initial kr diye

  Future<model.User> getUserDetail() async {
    User currentUser = _auth
        .currentUser!; // model .user nhi use kiye sirf user use kiye... FireBase wala user h bo
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    //return model.User(snap);// ye accept nhi krega
    ///model.user(followers:snap.data() as map<String,Dynamic>)['followers]
    ///sbke liye kroo same cheez time waste ho jaayega
    // user.dart me ek function bna lenge
    //jo doc snapshot ko input me lega and return a user model

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    //string coz user ko btayenge ki login succrssfull or not
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file, //ig photo wala file h ye
  }) async {
    //async function h
    String res = "Some error occured";
    try {
      //kuch validation krna padega pehle
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // again sb filled h
        //user ko authentication me add krenge
        //return type is future
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // cred me user ka info rha name uid wagera sb
        //email and password get stored in authentication tab

        //Photo profile wala upload kr rha
        String photoUrl = await StorageMethods()
            .uploadImagaeToStorage('profilePics', file, false);

        //User class me input denge
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          following: [],
          followers: [],
        );
        //baaki sb chee database me store krenge
        //id chahiye jo ki uid hoga->user folder hoga doc me uid hoga
        //future void type ka function h
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson()

                //User class ka use kr rhe ab to issue nhi h
                //   {
                //   //override ho jaayega same hone me
                //   'username': username,
                //   'uid': cred.user!.uid,
                //   'email': email,
                //   'bio': bio,
                //   'followers': [],
                //   'following': [],
                //   'photoUrl': photoUrl, //photo ka bhi link aa gya
                // }
                );

        // agar uid nhi chahie app me khii as such kaam nhi h to
        //await _firestore.collection('users').add({});
        res = "success";
      }
    } catch (err) {
      //iske beech me on FirebaseException catch{if(err.code=='email-val')print_.}//bt firebase me pehles se rehta h isliye nhi kr rhe h
      res = err
          .toString(); // agar koi error aaya to phir uss error ko show kr dega
    }
    return res;
  }

  //loggin in user->similar to signup screen
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // user credential return krega...need nhi h as such store krne ka firebase ke database me->FUTURE TYPE bhi h
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    }
    //yha pe bhi on firebase exception wala portion daal skte h->"user-not-found"->iske liye alg se msg daal skte h "wrong-password" "min-password-size"
    //baad me change krke customise krenge yaad rakhna...thoda diff hone ke liye
    catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
