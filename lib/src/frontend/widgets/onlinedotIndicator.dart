import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/controller/models/userModel.dart';
import 'package:chathub/src/controller/utils/userstate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;

  OnlineDotIndicator({
    @required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    final _db = Provider.of<FirebaseServices>(context);
    getColor(int state) {
      switch (numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.red;
      }
    }

    return Align(
      alignment: Alignment.bottomRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _db.getUserStream(
          uid: uid,
        ),
        builder: (context, snapshot) {
          MyUser user;

          if (snapshot.hasData && snapshot.data.data() != null) {
            user = MyUser.fromFirestore(snapshot.data.data());
          }

          return Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 5, bottom: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getColor(user?.state),
            ),
          );
        },
      ),
    );
  }
}
