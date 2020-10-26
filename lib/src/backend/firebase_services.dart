import 'package:chathub/src/controller/models/message.dart';
import 'package:chathub/src/controller/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  MyUser myuser;

  MyUser get currentUser => MyUser(
      displayName: _auth.currentUser.displayName ?? " ",
      email: _auth.currentUser.email,
      uid: _auth.currentUser.uid,
      photoUrl: _auth.currentUser.photoURL,
      phoneNumber: _auth.currentUser.phoneNumber);

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
      Message message, MyUser sender, MyUser receiver) async {
    var map = message.toMap();

    await _db
        .collection("messages")
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);

    return await _db
        .collection("messages")
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Stream<List<Map>> messageList(MyUser sender, MyUser reciever) {
    return _db
        .collection('messages')
        .doc(sender.uid)
        .collection(reciever.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((event) => event.docs)
        .map((snapdoc) => snapdoc.map((e) => e.data()).toList());
        // print("Data from firebase : ${e.data()}");
  }
}
