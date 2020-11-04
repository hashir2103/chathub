import 'package:chathub/src/backend/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  User _user;
  String _userId;
  String _firstLetter;
  FirebaseServices _auth = FirebaseServices();

  User get getUser => _user;

  String get getUserId => _userId;
  String get getUserNameFirstLetter => _firstLetter;

  void refreshUser() async {
    _user = _auth.getUserDetail();
    _userId = _user.uid;
    _firstLetter = _user.displayName[0];
    notifyListeners();
  }
}
