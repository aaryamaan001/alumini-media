import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/add_post_screen.dart';
import 'package:social_media_app/screens/feed_screen.dart';
import 'package:social_media_app/screens/news/news_bar.dart';
import 'package:social_media_app/screens/profile_screen.dart';
import 'package:social_media_app/screens/search_screen.dart';

const webScreenSize = 600; //beyond this web screen will be displayed

//navigation baar me children jo hoga vhi h
List<Widget> homeScreenItems = [
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
  const SearchScreen(),
  const FeedScreen(),
  const AddPostScreen(),
  const NewsBar(),
];
