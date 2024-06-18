import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/global_variables.dart';
import 'package:social_media_app/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/ic_social_media.svg',
                color: primaryColor,
                height: 36,
              ),
              // actions: [
              //   IconButton(
              //       onPressed: () {}, icon: const Icon(Icons.message_outlined)),
              // ],
            ),
      body: StreamBuilder(
        //real time data chahiye...mtlb jaise hi like kr rhe ho like badhe n reflect ho
        //jaise hi post kre vo upr aaye
        // get use krte the doc wala
        // vo issue h kyuki usme data one time chahiye hota h
        // n specific user ka h hota tha
        //real time ke liye streams use krte
        stream: FirebaseFirestore.instance
            .collection('posts')
            .snapshots(), //get use nhi kr skte future return krta h->snapshot specific id ke liye bhi ho skta h bt humko sb id ka chahiye
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          //main function ke type h
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(
                  horizontal: width > webScreenSize ? width * 0.3 : 0,
                  vertical: width > webScreenSize ? 15 : 0),
              child: PostCart(snap: snapshot.data!.docs[index].data()),
            ), //doc me jitne bhi post rhenge usko uthayega ne dega itemcount->total post idx will help in traversing through the index
          );
        },
      ),
    );
  }
}
