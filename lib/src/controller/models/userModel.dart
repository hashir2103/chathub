class MyUser {
  final String uid;
  final String email;
  final String displayName;
  final String phoneNumber;
  final String photoUrl;
  final int state;

  MyUser( 
      {this.uid,
      this.state,
      this.email,
      this.displayName,
      this.phoneNumber,
      this.photoUrl});

  Map<String, dynamic> toMap(MyUser user) {
    return {
      'uid': user.uid,
      'phoneNumber': user.phoneNumber,
      'email': user.email,
      'displayName': user.displayName ?? ' ',
      'photoUrl': user.photoUrl,
      'state' : user.state
    };
  }

  factory MyUser.fromFirestore(Map<String, dynamic> firestore) {
    if (firestore == null) return null;
    return MyUser(
        uid: firestore['uid'],
        phoneNumber: firestore['phoneNumber'],
        email: firestore['email'],
        photoUrl: firestore['photoUrl'],
        state : firestore['state'],
        displayName: firestore['displayName'] ?? " ");
  }
}
