import 'package:chathub/src/controller/models/contactModel.dart';
import 'package:chathub/src/controller/models/messageModel.dart';
import 'package:chathub/src/controller/models/userModel.dart';
import 'package:chathub/src/controller/utils/userstate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  // final userbloc = UserProvider();
  MyUser myuser;

  MyUser get currentUser => MyUser(
      displayName: _auth.currentUser.displayName ?? " ",
      email: _auth.currentUser.email,
      uid: _auth.currentUser.uid,
      photoUrl: _auth.currentUser.photoURL,
      phoneNumber: _auth.currentUser.phoneNumber);

  User getUserDetail() {
    return _auth.currentUser;
  }

  Future<MyUser> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _db.collection('users').doc(id).get();
      return MyUser.fromFirestore(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserCredential> signIn() async {
    try {
      GoogleSignInAccount _signIn = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuth = await _signIn.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: _signInAuth.accessToken, idToken: _signInAuth.idToken);
      UserCredential user = await _auth.signInWithCredential(credential);
      return user;
    } catch (e) {
      print('===========================================');
      print('error : ${e.toString()}');
      return null;
    }
  }

  Future<bool> checkForNewUser(User user) async {
    if (user != null) {
      var result = await _db
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();
      final List<DocumentSnapshot> docs = result.docs;
      //if user already register length of list will be greater than zero
      return docs.length <= 0 ? true : false;
    } else {
      print("Error Login In");
      return false;
    }
  }

  addUser(UserCredential user) {
    var userdata = user.user;
    myuser = MyUser(
        uid: userdata.uid,
        displayName: userdata.displayName ?? "Name",
        email: userdata.email,
        phoneNumber: userdata.phoneNumber,
        photoUrl: userdata.photoURL);
    _db.collection('users').doc(userdata.uid).set(myuser.toMap(myuser));
  }

  logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<List<MyUser>> fetchAllUsers() async {
    List<MyUser> userList = List<MyUser>();

    QuerySnapshot querySnapshot = await _db.collection("users").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(MyUser.fromFirestore(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(
      Message message, User sender, MyUser receiver) async {
    var map = message.toMap();

    await _db
        .collection("messages")
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);
    addToContact(senderId: sender.uid, recieverId: receiver.uid);
    return await _db
        .collection("messages")
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference getContactDoc({String of, String forContact}) {
    return _db
        .collection('users')
        .doc(of)
        .collection('contacts')
        .doc(forContact);
  }

  Future<void> addToSenderContact(
      String senderId, String recieverId, currentTime) async {
    DocumentSnapshot senderSnapshot =
        await getContactDoc(of: senderId, forContact: recieverId).get();
    if (!senderSnapshot.exists) {
      Contact contact = Contact(uid: recieverId, addedOn: currentTime);
      var contactMap = contact.toMap(contact);
      await getContactDoc(of: senderId, forContact: recieverId).set(contactMap);
    }
  }

  Future<void> addToRecieverContact(
      String senderId, String recieverId, currentTime) async {
    DocumentSnapshot recieverSnapshot =
        await getContactDoc(of: recieverId, forContact: senderId).get();
    if (!recieverSnapshot.exists) {
      Contact contact = Contact(uid: senderId, addedOn: currentTime);
      var contactMap = contact.toMap(contact);
      await getContactDoc(of: recieverId, forContact: senderId).set(contactMap);
    }
  }

  addToContact({String senderId, String recieverId}) async {
    Timestamp currentTime = Timestamp.now();
    await addToSenderContact(senderId, recieverId, currentTime);
    await addToRecieverContact(senderId, recieverId, currentTime);
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .snapshots();
  }

  Stream<QuerySnapshot> fetchLastMessageBetween(
      {@required String senderId, @required String recieverId}) {
    return _db
        .collection('messages')
        .doc(senderId)
        .collection(recieverId)
        .orderBy('timestamp')
        .snapshots();
  }

  Stream<List<Map>> messageList(User sender, MyUser reciever) {
    return _db
        .collection('messages')
        .doc(sender.uid)
        .collection(reciever.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((event) => event.docs)
        .map((snapdoc) => snapdoc.map((e) => e.data()).toList());
  }

  setImageMsg({String url, String senderId, String recieverId}) async {
    var timestamp = DateTime.now().toIso8601String();
    var time = timestamp.split('T')[1].substring(0, 5);
    Message _message;
    _message = Message.imageMessage(
        message: "IMAGE",
        senderId: senderId,
        receiverId: recieverId,
        photoUrl: url,
        time: time,
        timestamp: timestamp,
        type: 'image');
    var map = _message.toImageMap();
    await _db
        .collection("messages")
        .doc(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

    return await _db
        .collection("messages")
        .doc(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = stateToNum(userState);

    _db.collection("users").doc(userId).update({
      "state": stateNum,
    });
  }

  Future<void> editProfileImage(
      {@required String userId, @required String imgURL}) async {
    var user = getUserDetail();
    user.updateProfile(photoURL: imgURL);
    _db.collection("users").doc(userId).update({
      "photoUrl": imgURL,
    });
  }
  Future<void> editDisplayName(
      {@required String userId, @required String name}) async {
    var user = getUserDetail();
    user.updateProfile(displayName:name);
    _db.collection("users").doc(userId).update({
      "displayName": name,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      _db.collection("users").doc(uid).snapshots();
}
