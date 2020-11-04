import 'package:chathub/src/controller/bloc/callBloc.dart';
import 'package:chathub/src/controller/bloc/userbloc.dart';
import 'package:chathub/src/controller/models/callModel.dart';
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
  // MyUser currentUser;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var callMethods = Provider.of<CallMethods>(context);
    final user = Provider.of<UserProvider>(context);
    return (user != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: user.getUserId),
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
