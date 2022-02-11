import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/layouts/mobile_screen_layout.dart';
import 'package:tiktok/models/post.dart';
import 'package:tiktok/resources/storage_methods.dart';
import 'package:tiktok/screens/video_screen.dart';
import 'package:tiktok/utils/colors.dart';
import 'package:tiktok/utils/utils.dart';

class UploadPost extends StatefulWidget {
  const UploadPost({Key? key}) : super(key: key);

  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  //final bool isGallery;

  @override
  void initState() {
    _fetch();
    super.initState();
  }

  String photoUrl = "",
      userName = "",
      description = "",
      time = "",
      user_id = "",
      profImage = "";

  late File file;

  Uint8List? _file;

  final picker = ImagePicker();

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
              child: Text("Take a Photo"),
              onPressed: () async {
                /*Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });*/
                Navigator.of(context).pop();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  File? croppedFile = await ImageCropper.cropImage(
                    sourcePath: pickedFile.path,
                    aspectRatioPresets: [
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio3x2,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio16x9
                    ],
                    androidUiSettings: AndroidUiSettings(
                      toolbarTitle: 'Cropper',
                      toolbarColor: Colors.black,
                      toolbarWidgetColor: Colors.white,
                      activeControlsWidgetColor: Colors.teal,
                      initAspectRatio: CropAspectRatioPreset.original,
                      lockAspectRatio: false,
                    ),
                    iosUiSettings: IOSUiSettings(
                      minimumAspectRatio: 1.0,
                    ),
                  );
                  if (croppedFile != null) {
                    //File imageFile = File(croppedFile.toString());
                    Uint8List imageRaw = await croppedFile.readAsBytes();
                    setState(() {
                      _file = imageRaw;
                      print('this is file path = $_file');
                    });
                  }
                }
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text("Photo from Gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  File? croppedFile = await ImageCropper.cropImage(
                    sourcePath: pickedFile.path,
                    aspectRatioPresets: [
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio3x2,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio16x9
                    ],
                    androidUiSettings: AndroidUiSettings(
                      toolbarTitle: 'Cropper',
                      toolbarColor: Colors.black,
                      toolbarWidgetColor: Colors.white,
                      activeControlsWidgetColor: Colors.teal,
                      initAspectRatio: CropAspectRatioPreset.original,
                      lockAspectRatio: false,
                    ),
                    iosUiSettings: IOSUiSettings(
                      minimumAspectRatio: 1.0,
                    ),
                  );
                  if (croppedFile != null) {
                    Uint8List imageRaw = await croppedFile.readAsBytes();
                    setState(() {
                      _file = imageRaw;
                      print('this is file path = $_file');
                    });
                  }
                }
                /* Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });*/
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _selectVideo(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Create a Video Post"),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Take a Video"),
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VideoScreen()));
                //Navigator.of(context).pop();
                final file = await picker.pickVideo(source: ImageSource.camera);
                Uint8List imageRaw = await file!.readAsBytes();
                setState(() {
                  _file = imageRaw;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Video from Gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                final file =
                    await picker.pickVideo(source: ImageSource.gallery);
                Uint8List imageRaw = await file!.readAsBytes();
                setState(() {
                  _file = imageRaw;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _selectAudio(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Create a Audio Post"),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Record a Audio"),
              onPressed: () async {
                Navigator.of(context).pop();
                final file = await FilePicker.platform.pickFiles();
                if (file == null) return;
                /* Uint8List imageRaw = await file.readAsBytes();
                setState(() {
                  _file = imageRaw;
                });*/
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Audio from Files"),
              onPressed: () {},
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> uploadData() async {
    setState(() {
      isLoading = true;
    });

    String res = "Some error";
    try {
      String docId = FirebaseFirestore.instance.collection('posts').doc().id;

      String profImage =
          await StorageMethods().uploadImageToStorage('posts', _file!, true);

      Post post = Post(
        description: _descriptionController.text,
        uid: user_id,
        username: userName,
        likes: [],
        postId: docId,
        datePublished: DateTime.now(),
        postUrl: profImage,
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
      res = "Success";

      if (res == "Success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted! :)',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (e) {
      res = e.toString();
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        e.toString(),
      );
    }
    return res;
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

          Fluttertoast.showToast(msg: userName);
        });
      }).catchError((e) {
        print(e);
      });
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
    // final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.add_photo_alternate_outlined,
                  ),
                  onPressed: () => _selectImage(context),
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.slow_motion_video_sharp,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VideoScreen()));
                      },
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.audiotrack,
                      ),
                      onPressed: () => _selectAudio(context),
                    ),
                  ],
                )
              ],
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
                  onPressed: () => uploadData().whenComplete(() =>
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MobileScreenLayout()))),
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
}
