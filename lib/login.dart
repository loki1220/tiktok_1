import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:tiktok/welcome_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final _auth = FirebaseAuth.instance;

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Login to your account",
                        style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    key: _formkey,
                    width: 500,
                    margin: EdgeInsets.only(bottom: 25),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      autofocus: false,
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please enter your Email");
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]")
                            .hasMatch(value)) {
                          return ("Please enter a Valid Email");
                        }
                      },
                      onSaved: (value) {
                        email.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        labelText: "Email Id",
                      ),
                    ),
                  ),
                  Container(
                    width: 500,
                    margin: EdgeInsets.only(bottom: 25),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      autofocus: false,
                      controller: password,
                      obscureText: true,
                      /*validator: (value) {
                        RegExp regex = new RegExp(r'^,{8,}$');
                        if (value!.isEmpty) {
                          return ("Password is must");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter valid password(Min. 8 character)");
                        }
                      },
                      onSaved: (value) {
                        password.text = value!;
                      },*/
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        labelText: "Password",
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(bottom: 5, right: 5, left: 5, top: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                        )),
                    child: MaterialButton(
                      elevation: 5,
                      minWidth: double.infinity,
                      height: 60,
                      color: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        email.text.isEmpty
                            ? ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                content:
                                    Text("Please Enter a Email to Continue"),
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.red,
                              ))
                            : password.text.isEmpty
                                ? ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content:
                                        Text("Please Enter a Valid password"),
                                    duration: Duration(seconds: 5),
                                    backgroundColor: Colors.red,
                                  ))
                                : Navigator.of(context).push(MaterialPageRoute(
                                    builder: (c) => WelcomePage()));
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Don't have an account?",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        children: [
                          TextSpan(
                            text: "Signup",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupPage()));
                              },
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
