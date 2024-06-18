import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/resources/auth_methods.dart';
import 'package:social_media_app/responsive/mobile_screen_layout.dart';
import 'package:social_media_app/responsive/responsive_layout_screen.dart';
import 'package:social_media_app/responsive/web_screen_layout.dart';
import 'package:social_media_app/screens/login_screen.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/utils.dart';
import 'package:social_media_app/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController =
      TextEditingController(); //email id store kr lega ye
  final TextEditingController _passwordController =
      TextEditingController(); // password ko store krega ye

  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading =
      false; //signup hone me thoda time lagta h -> utne time tk loading dikhayega

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose(); //space khali krne ke liye
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery); //camera bhi kr skte

    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file:
          _image!, //firebase storage me save krenge saare image vhii pe store hote h
      //image selected from the gallary chose ho gya
    );

    setState(() {
      _isLoading = false; //sign up button me use ho rha
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      // sign up sucessful ho gya h to kya krna h
      //direct mai home screen me chle jaaye
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (contest) => const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),
      ));
    }
  }

  //login screen me jaane ke liye
  void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (contest) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // imaage abhi bhi top me hi tha
            // flixible widget
            Flexible(
              child: Container(),
              flex: 1,
            ),
            //svg image
            SvgPicture.asset(
              'assets/ic_social_media.svg',
              color: primaryColor,
              height: 64,
            ),
            const SizedBox(
              height: 16,
            ),

            //circular widget for accepting the profile type ka from the gallary
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(
                            _image!), //imphone me kaam krne ke liye info.plist file me kuch update krna padta h
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg'),
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed:
                            selectImage, //image picker dependency add kiye
                        icon: Icon(Icons
                            .add_a_photo))) //color bhi change kr skte h icon ka abhi to white h
              ],
            ),
            const SizedBox(
              height: 28,
            ),
            //text field input for username
            TextFieldInput(
              hinText: 'Enter your username',
              textInputType: TextInputType.text,
              textEditingController: _usernameController,
            ),
            const SizedBox(
              height: 18,
            ),
            //text field input for mail
            TextFieldInput(
              hinText: 'Enter your email',
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailController,
            ),
            const SizedBox(
              height: 18,
            ),
            //text field input for password
            TextFieldInput(
              hinText: 'Enter your password',
              textInputType: TextInputType.text,
              textEditingController:
                  _passwordController, //text editing controller value store kr rha h password me
              // password h
              isPass: true,
            ),
            const SizedBox(
              height: 18,
            ),
            TextFieldInput(
              hinText: 'Enter your bio',
              textInputType: TextInputType.text,
              textEditingController: _bioController,
            ),
            const SizedBox(
              height: 18,
            ),
            // button for login
            InkWell(
              onTap: signUpUser,
              child: Container(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text('Sign up'),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  color: blueColor,
                ), //text se
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Flexible(
              child: Container(),
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("Have an account?"),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                ),
                GestureDetector(
                  onTap: navigateToLogin,
                  child: Container(
                    child: Text(
                      "Login.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            )

            // transition to signing
          ],
        ),
      )),
    );
  }
}
