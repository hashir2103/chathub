import 'dart:io';
import 'dart:async';

import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/backend/firebasestorage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {
  //streamControllers
  final _imgUrl = BehaviorSubject<String>.seeded('');
  final _imgUploading = BehaviorSubject<bool>.seeded(false);

  //stream getter
  Stream<String> get imgUrl => _imgUrl.stream;
  Stream<bool> get imgUploading => _imgUploading.stream;
  Stream<bool> get imgloading =>
      CombineLatestStream.combine2(imgUrl, imgUploading, (a, b) {
        if (a.length > 2 && b == false)
          return false;
        else
          return true;
      });

  //stream setter
  Function(String) get changeNoImgUrl => _imgUrl.sink.add;
  Function(bool) get changeImgUploading => _imgUploading.sink.add;

  // varaibles
  final _picker = ImagePicker();
  final storageService = FirebaseStorageService();
  final _db = FirebaseServices();

  //Transformer of stream to validate data

  //dispose
  dispose() {
    _imgUrl.close();
    _imgUploading.close();
  }

  //Functions

  pickImage(ImageSource source, {senderId, recieverId}) async {
    // ==> it will run if u not given permission if u already give this will skip

    await Permission.photos.request();
    await Permission.camera.request();

    //we have to check permission for ios it work fine with android but in ios program doesnt know where u left of.
    var permissionStatus = [
      await Permission.photos.status,
      await Permission.camera.status
    ];
    PickedFile image;
    // ignore: unused_local_variable
    File croppedFile;
    if (permissionStatus[0].isGranted || permissionStatus[1].isGranted) {
      image = await _picker.getImage(source: source);
      if (image != null) {
        //getting image properties
        ImageProperties properties =
            await FlutterNativeImage.getImageProperties(image.path);

        //crop image
        //portrait
        if (properties.height > properties.width) {
          var yOffset = (properties.height - properties.width) / 2;
          croppedFile = await FlutterNativeImage.cropImage(image.path, 0,
              yOffset.toInt(), properties.width, properties.width);
        }
        //landscape
        else if (properties.width > properties.height) {
          var xOffset = (properties.width - properties.height) / 2;
          croppedFile = await FlutterNativeImage.cropImage(image.path,
              xOffset.toInt(), 0, properties.height, properties.height);
        }
        //already squared
        else {
          croppedFile = File(image.path);
        }

        //Resize
        File compressedFile = await FlutterNativeImage.compressImage(
            croppedFile.path,
            quality: 100,
            targetWidth: 600,
            targetHeight: 600);

        changeImgUploading(true);
        var imageUrl =
            await storageService.uploadProductImage(file: compressedFile);
        _db.setImageMsg(
            url: imageUrl, senderId: senderId, recieverId: recieverId);
        changeNoImgUrl(imageUrl);
        changeImgUploading(false);
      } else {
        print("No path Received");
      }
    } else {
      print("Grant Premission an try again");
    }
  }
}
