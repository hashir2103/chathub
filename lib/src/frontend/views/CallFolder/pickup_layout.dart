import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/controller/bloc/callBloc.dart';
import 'package:chathub/src/controller/models/callModel.dart';
import 'package:chathub/src/controller/models/userModel.dart';
import 'package:chathub/src/frontend/views/CallFolder/pickupScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickupLayout extends StatefulWidget {
  final Widget scaffold;

  PickupLayout({
    @required this.scaffold,
  });

  @override
  _PickupLayoutState createState() => _PickupLayoutState();
}

class _PickupLayoutState extends State<PickupLayout> {
  MyUser currentUser;
  @override
  void initState() {
    var _db = Provider.of<FirebaseServices>(context, listen: false);
    currentUser = _db.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var callMethods = Provider.of<CallMethods>(context);
    return (currentUser.uid.isNotEmpty)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: currentUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.data() != null) {
                Call call = Call.fromMap(snapshot.data.data());
                
                if (!call.hasDialled) {
                  return PickupScreen(call: call);
                }
              }
              return widget.scaffold;
            },
          )
        : Scaffold(
            body: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ));
  }
}
