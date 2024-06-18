import 'package:flutter/material.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  //change notifier ka functionality use krenge kuch kuch
  //kuch functions inherit krenge
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  //private bna lo user ko nhi to bug aayega
  //private ko access krne ke liye

  User get getUser => _user!; //not null hoga jab call krenge tb

  Future<void> refreshUser() async {
    //function to update the value of the user
    //auth method me function bnayege to get the user detail
    //mob screen me bnaye the same vha bnayenge
    User user = await _authMethods
        .getUserDetail(); //abhi abhi funvtioin bnaye authmethod and user.dart me
    _user = user;
    notifyListeners(); // ye kya krega ki it will inform all the listener of the user provider that the data of the user has changed so you need to update your value
  }
}
