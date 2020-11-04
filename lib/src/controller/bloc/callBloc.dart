import 'package:chathub/src/controller/models/callModel.dart';
import 'package:chathub/src/controller/models/userModel.dart';
import 'package:chathub/src/frontend/views/CallFolder/CallScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CallMethods {
  Future<DocumentSnapshot> doc() =>
      FirebaseFirestore.instance.collection('channel').doc('channel1').get();

  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection('calls');

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.doc(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  dial({User from, MyUser to, context}) async {
    var channeldata = await doc();
    Call call = Call(
      callerId: from.uid,
      callerName: from.displayName,
      callerPic: from.photoURL,
      receiverId: to.uid,
      receiverName: to.displayName,
      receiverPic: to.photoUrl,
      channel_name: channeldata.data()['channel_name'],
      token:channeldata.data()['token']
    );

    bool callMade = await makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}
