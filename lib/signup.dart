import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/login.dart';
import 'package:provider/provider.dart';

import 'auth_services.dart';

class SignupPage extends StatefulWidget {
  //bool _secureText = true;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  //final _auth = FirebaseAuth.instance;

  String? errorMessage;

  final _formkey = GlobalKey<FormState>();

  bool _secureText = true;
  bool _securityText = true;

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
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
        body: SingleChildScrollView(
          child: Column(
            key: _formkey,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create an account",
                    style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                autofocus: false,
                controller: fnameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  RegExp regex = new RegExp(r'^.{30,}$');
                  if (value!.isEmpty) {
                    return ("First name cannot be empty");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Enter the valid name(Min. 30 Characters)");
                  }
                  return null;
                },
                onSaved: (value) {
                  fnameController.text = value!;
                },
                maxLength: 30,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  labelText: "First Name",
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: lnameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Last name cannot be empty");
                  }
                  return null;
                },
                onSaved: (value) {
                  lnameController.text = value!;
                },
                maxLength: 20,
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  labelText: "Last Name",
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                /*validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please enter your Email");
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]")
                        .hasMatch(value)) {
                      return ("Please enter a Valid Email");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    emailController.text = value!;
                  },*/
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  labelText: "Email Id",
                ),
              ),
              SizedBox(
                height: 35,
              ),
              TextFormField(
                controller: numController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.length < 10) return 'Provide mininum 10 numbers';

                  if (value.isEmpty) {
                    return ("Phone number cannot be empty");
                  }
                },
                maxLength: 10,
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  labelText: "Phone Number",
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: passwordController,
                validator: (value) {
                  RegExp regex = new RegExp(r'^.{8,}$');
                  if (value!.isEmpty) {
                    return ("Password is required for login");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Enter Valid Password(Min. 8 Character)");
                  }
                },
                onSaved: (value) {
                  passwordController.text = value!;
                },
                decoration: InputDecoration(
                  counterText: "",
                  suffixIcon: IconButton(
                    icon: Icon(
                        _secureText ? Icons.remove_red_eye : Icons.security),
                    onPressed: () {
                      setState(() {
                        _secureText = !_secureText;
                      });
                    },
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  labelText: "Password",
                ),
                obscureText: _secureText,
              ),
              SizedBox(
                height: 35,
              ),
              TextFormField(
                controller: confirmpasswordController,
                validator: (value) {
                  if (confirmpasswordController.text !=
                      passwordController.text) {
                    return "Password don't match";
                  }
                  return null;
                },
                onSaved: (value) {
                  confirmpasswordController.text = value!;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                        _securityText ? Icons.remove_red_eye : Icons.security),
                    onPressed: () {
                      setState(() {
                        _securityText = !_securityText;
                      });
                    },
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  labelText: "Confirm Password",
                ),
                obscureText: _securityText,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Container(
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
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      final String email = emailController.text.trim();
                      final String password = passwordController.text.trim();

                      if (email.isEmpty) {
                        print("Email is Empty");
                      } else {
                        if (password.isEmpty) {
                          print("Password is Empty");
                        } else {
                          userSetup(
                              emailController.text, passwordController.text);
                          context
                              .read<AuthService>()
                              .signUp(
                                email,
                                password,
                              )
                              .then((value) async {
                            User? user = FirebaseAuth.instance.currentUser;

                            await FirebaseFirestore.instance
                                .collection("uid")
                                .doc(user!.uid)
                                .set({
                              'uid': user.uid,
                              'email': emailController,
                              'password': passwordController,
                            });
                          });
                        }
                      }
                    },
                    color: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Sign In",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                    text: "Already have an account?",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    children: [
                      TextSpan(
                        text: "Signin",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                      ),
                    ]),
              ),
            ],
          ),
        ));
  }

  Future<void> userSetup(
    String email,
    String password,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    var firebaseUser = FirebaseAuth.instance.currentUser;
    CollectionReference user = FirebaseFirestore.instance
        .collection("uid")
        .doc(firebaseUser?.uid)
        .set({
      "UserEmail": email,
      "UserPassword": password,
      "uid": uid,
    }) as CollectionReference<Object?>;

    return;
  }
}
