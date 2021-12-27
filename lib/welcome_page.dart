import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/home.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                      //margin: EdgeInsets.only(left: 30, top: 200),
                      padding: EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: _fetch(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done)
                            return Text(
                              "Loading data...Please wait",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.pinkAccent),
                            );
                          return Text(
                            "$myfirstName" + " $mylastName",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.pinkAccent),
                          );
                        },
                      )),
                ],
              )
            ],
          ),
          Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              color: Colors.pinkAccent,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                "Logout",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ),
          ]),
          SizedBox(
            height: 30,
          ),
        ],
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
