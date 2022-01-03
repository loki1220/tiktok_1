import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/add_image.dart';
import 'package:transparent_image/transparent_image.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var myfirstName;
  var mylastName;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black38,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xffE6F7FF),
              size: 20,
            ),
            onPressed: () {
              // passing this to our root
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "App Name",
            style: TextStyle(color: Color(0xffE6F7FF)),
          ),
          actions: [
            CircleAvatar(
              child: Icon(Icons.account_circle_sharp),
            )
          ],
          //centerTitle: true,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.home_outlined,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search_outlined,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddImage()));
                },
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none_outlined,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.settings_outlined,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          //margin: EdgeInsets.only(left: 30, top: 200),
                          padding: EdgeInsets.all(10),
                          child: FutureBuilder(
                            future: _fetch(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return Text(
                                  "Loading data...Please wait",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xffE6F7FF)),
                                );
                              }
                              return Text(
                                "$myfirstName" + " $mylastName",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xffE6F7FF)),
                              );
                            },
                          )),
                    ]),
                Container(
                  height: 565,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('imageURLs')
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              height: 50,
                              width: 50,
                              padding: EdgeInsets.all(4),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: (snapshot.data! as QuerySnapshot)
                                      .docs
                                      .length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.all(1),
                                      child: FadeInImage.memoryNetwork(
                                          fit: BoxFit.cover,
                                          placeholder: kTransparentImage,
                                          image:
                                              (snapshot.data! as QuerySnapshot)
                                                  .docs[index]
                                                  .get('url')),
                                    );
                                  }),
                            );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _fetch() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) async {
        myfirstName = ds.data()!["firstName"];
        mylastName = ds.data()!["lastName"];
      }).catchError((e) {
        print(e);
      });
    }
  }
}
