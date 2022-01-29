import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/models/post.dart';
import 'package:tiktok/providers/user_providers.dart';
import 'package:tiktok/resources/auth_methods.dart';
import 'package:tiktok/resources/firestore_methods.dart';
import 'package:tiktok/utils/colors.dart';
import 'package:tiktok/utils/utils.dart';

class UploadPost extends StatefulWidget {
  const UploadPost({Key? key}) : super(key: key);

  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  @override
  void initState() {
    _fetch();
    super.initState();
  }

  String photoUrl = "",
      userName = "",
      description = "",
      time = "",
      user_id = "";

  late File file;

  /* handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = file;
    });
  }*/

  /*handleChooseFromGallery() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }*/

  Uint8List? _file;

  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Create a Post"),
          children: <Widget>[
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text("Take a photo"),
              onPressed: //handleTakePhoto
                  () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Choose from Gallery"),
                onPressed: //handleChooseFromGallery
                    () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
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
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: clearImage,
              ),
              title: Text(
                "Post to",
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  onPressed: () => uploadData(),
                  /* postImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProvider.getUser.photoUrl,
                  ),*/
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (photoUrl != "")
                      CircleAvatar(backgroundImage: NetworkImage(photoUrl)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 5,
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
  }

  Future<void> uploadData() async {
    try {
      String docId = FirebaseFirestore.instance.collection('posts').doc().id;

      Post post = Post(
        description: _descriptionController.text,
        uid: user_id,
        username: userName,
        likes: [],
        postId: docId,
        datePublished: DateTime.now(),
        postUrl: "",
        profImage: photoUrl,
      );

      FirebaseFirestore.instance
          .collection('posts')
          .doc(docId)
          .set(post.toJson());

      FirebaseFirestore.instance
          .collection('users')
          .doc(user_id)
          .collection("MyPosts")
          .doc(docId)
          .set(post.toJson());

      print('success');
    } catch (e) {
      String res = e.toString();
      print('error got : ' + res);
    }
  }

  _fetch() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) async {
        setState(() {
          photoUrl = ds.data()!["photoUrl"];
          userName = ds.data()!["username"];
          user_id = ds.data()!["uid"];

          Fluttertoast.showToast(msg: photoUrl);
        });
      }).catchError((e) {
        print(e);
      });
    }
  }
}
