import 'package:flutter/cupertino.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/resources/FirebaseMethods.dart';

class UserProvider with ChangeNotifier {
  User _user;
  FirebaseMethods _authMethods = FirebaseMethods();

  User get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;

    notifyListeners();
  }
}
