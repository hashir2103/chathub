import 'package:chathub/src/backend/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  User _user;
  String _userId;
  String _name;
  String _firstLetter;
  String _photoURL;
  FirebaseServices _auth = FirebaseServices();

  User get getUser => _user;

  String get getUserId => _userId;
  String get getPhotoURL => _photoURL;
  String get getUserNameFirstLetter => _firstLetter;
  String get getUserName => _name;

  Future<void> refreshUser() async {
    _user = _auth.getUserDetail();
    _userId = _user.uid;
    _firstLetter = _user.displayName[0];
    _photoURL = _user.photoURL;
    _name = _user.displayName;
    notifyListeners();
  }
}
