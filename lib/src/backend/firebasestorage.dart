import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  final storage = FirebaseStorage.instance;

  Future<String> uploadProductImage(
      {@required File file}) async {
    try {
      var snapshot = await storage
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}')
          .putFile(file)
          .onComplete;

      //this will give public url for image
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('======$e=======');
      return null;
    }
  }
}
