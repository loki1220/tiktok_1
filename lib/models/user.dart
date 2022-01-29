import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String fullname;
  final String uid;
  final String photoUrl;
  final String email;
  final String phone;

  const User({
    required this.fullname,
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.phone,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      fullname: snapshot["fullname"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      phone: snapshot["phone"],
    );
  }

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "phone": phone,
      };
}
