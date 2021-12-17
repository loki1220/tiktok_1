import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Stream<User?> loginstate = FirebaseAuth.instance.idTokenChanges();

  login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Logged In";
    } catch (e) {
      return e;
    }
  }

  signUp(String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        User? user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance.collection("uid").doc(user?.`uid).set({
          'uid': user?.uid,
          'email': email,
          'password': password,
        });
      });
      return "Signed Up";
    } catch (e) {
      return e;
    }
  }
}
