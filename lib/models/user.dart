import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String fullname;
  final String username;
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
      fullname: snapshot["fullname"],
      username: snapshot["username"],
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

/*
class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? photoUrl;

  UserModel(
      {this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.phone,
      this.photoUrl});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        phone: map['phoneNumber'],
        photoUrl: map["photoUrl"]);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phone,
      "photoUrl": photoUrl,
    };
  }
}
*/
