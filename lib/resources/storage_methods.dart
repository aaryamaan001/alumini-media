import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //uid ke liye firebase auth chahiye
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //add image to firebase storage

  //to store normal photo and profile photo
  Future<String> uploadImagaeToStorage(
      String childName, Uint8List file, bool isPost) async {
    //childname naam ka folder bnayege
    //data type h reference

    //try catch me isliye nhi daal rhe coz isko _auto file me hi upload kr rhe h
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!
        .uid); //ref ispointer to the file in the storage-->child is a folder weather it exist or not
    //profile -> uid->file

    //ref me uid use kiye h->but post ke liye uid nhi use kr skte same ho jaayega
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id); //Post->UiD->1 user ka saara post
    }

    //upload krna h ab
    //ref.putFile(file);//web nhi kr rhe hote to
    UploadTask uploadTask = ref.putData(file); //Uint8list

    TaskSnapshot snap = await uploadTask; //iske liye async krna padega
    String downloadURL = await snap.ref
        .getDownloadURL(); //download url of the file dega ye->network image se access kr skte phir to shi rhe na ekdum

    return downloadURL;
  }
}
