import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0; // ye bottom navigation bar ko color krna ke liye
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  //Web screen ke liye alg se kro
  //Mobile screen ke liye alg se kroo isse achcha state management krte h
  //Provider package use kr rhe h state management ke liye

  // String username = "";

  // @override
  // void initState() {
  //   //username lena h async hoga
  //   //init state async nhi ho skta bt use andar ka function asyn ho skta
  //   super.initState();
  //   getUserName();
  // }

  // void getUserName() async {
  //   //fireBase se data fetch krne ka tareeka
  //   //type document snapshot hota h
  //   //document se fetch kr rhe hote h one time ke liye
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();

  //   // snap ke bhut function hote ...ki exist krta h ki nhi..abhi to pta h to check krne ka need nhi
  //   //.data use krke poora data de dega
  //   setState(() {
  //     //username = snap.data()!['username'];// dekho ! lgane ke baad bhi error aa rha tha -> [useranme] this bracket is not supported by snap.data iske liye -> Document snapshot object h
  //     username = (snap.data() as Map<String, dynamic>)[
  //         'username']; //map is the subtype of object to we can say that obj is a map
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    //model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
        body: PageView(
          children: homeScreenItems,

          //physics:NeverScrollablePhysics ,
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: _page == 0 ? primaryColor : secondaryColor,
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: _page == 1 ? primaryColor : secondaryColor,
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _page == 2 ? primaryColor : secondaryColor,
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle,
                  color: _page == 3 ? primaryColor : secondaryColor,
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.newspaper,
                  color: _page == 4 ? primaryColor : secondaryColor,
                ),
                label: '',
                backgroundColor: primaryColor),
          ],
          onTap: navigationTapped,
        ) //bottom navigationbar widget bhi use kr skte,
        );
  }
}
