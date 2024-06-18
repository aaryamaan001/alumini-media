import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/providers/user_provider.dart';
import 'package:social_media_app/resources/firestore_methods.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file; //can be null-> one screen : other screen

  final TextEditingController _descriptionController =
      TextEditingController(); //dispose bhi to krna h

  //linear indicator hoga ab
  bool _isLoading = false;

  //upload the image//profile pic jaise upload kiye the waise
  void postImage(
    // ye sb info provider ke karan mil jaayega auth method se
    String uid,
    String username,
    String profileImage,
  ) async {
    //function yha nhi sirestore methods.dart file me bnayenge
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profileImage);

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar("Posted!", context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  // ye to upload wale screen ka h
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a post'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  //when we take a photo...dismiss the dialog box
                  Navigator.of(context).pop(); // ye dialog box ko htayega
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  // photo le liya ab ui me changes laane padega
                  //set state use krna padega
                  setState(() {
                    _file = file;
                  });
                },
              ),
              //Gallary
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text('Choose from gallary'),
                onPressed: () async {
                  //when we take a photo...dismiss the dialog box
                  Navigator.of(context).pop(); // ye dialog box ko htayega
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  // photo le liya ab ui me changes laane padega
                  //set state use krna padega
                  setState(() {
                    _file = file;
                  });
                },
              ),

              //cancel
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () async {
                  //when we take a photo...dismiss the dialog box
                  Navigator.of(context).pop(); // ye dialog box ko htayega
                },
              )
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //user ka profile wagera show hona h na
    //Provider ka use krenge
    final User user = Provider.of<UserProvider>(context).getUser;
    final String profileUrl =
        Provider.of<UserProvider>(context).getUser.photoUrl;
    // print(profileUrl);

    //centered button chahiye to isliye vo kr rhe h
    //container user

    return _file == null
        ? Stack(
            children: [
              Opacity(
                opacity: 0.5,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Image(
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1491975474562-1f4e30bc9468?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                    fit: BoxFit.cover, // Fills the entire screen
                    height: double
                        .infinity, // Ensures the image covers the entire height
                    width: double.infinity,
                    // Ensures the image covers the entire width
                  ),
                ),
              ),
              Center(
                child: IconButton(
                  icon: Icon(
                    Icons.upload,
                    size: 110,
                    color: const Color.fromARGB(255, 231, 222, 222),
                  ),
                  onPressed: () => _selectImage(context),
                ),
              ),
            ],
          )
        :

        //2 cond h ek jb kuch file select nhi kiye honge gallary se n 2nd
        // jb file select kiye honge gallary se

        Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () =>
                        postImage(user.uid, user.username, user.photoUrl),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ))
              ],
            ),
            body: Column(
              //to make linear indicator
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(profileUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Write a caption for your post....',
                          border: InputBorder.none,
                        ),
                        maxLines:
                            8, // text controller ka length badh jaayega max itna tk...description
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
