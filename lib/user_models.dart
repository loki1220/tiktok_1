class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? Uint8List;
  String? photoUrl;

  UserModel({
    this.uid,
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
      photoUrl: map['photoUrl'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phone,
      'photoUrl': photoUrl,
    };
  }
}
