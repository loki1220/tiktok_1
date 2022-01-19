import 'package:tiktok/models/user.dart';
import 'package:flutter/cupertino.dart';
import '../resources/auth_metrhods.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  final AuthMethods _authMethods = AuthMethods();

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
