import 'dart:async';

import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/controller/bloc/callBloc.dart';
import 'package:chathub/src/controller/models/call.dart';
import 'package:chathub/src/controller/models/userModel.dart';
import 'package:chathub/src/controller/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CallScreen extends StatefulWidget {
  final Call call;

  const CallScreen({Key key, @required this.call}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  StreamSubscription callend;
  MyUser currentUser;

  @override
  void initState() {
    var _db = Provider.of<FirebaseServices>(context, listen: false);
    currentUser = _db.currentUser;
    var callmethods = Provider.of<CallMethods>(context, listen: false);
    callend = callmethods.callStream(uid: currentUser.uid).listen((event) {
      switch (event.data()) {
        case null:
          Navigator.of(context).pop();
          break;
        default:
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    callend.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var callmethods = Provider.of<CallMethods>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Calling..",
              style: TextStyles.loginButton,
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              color: Colors.red,
              child: Icon(
                Icons.call_end,
                color: Colors.white,
              ),
              onPressed: () {
                if (widget.call == null) {
                  Navigator.of(context).pop();
                }
                callmethods.endCall(call: widget.call);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
