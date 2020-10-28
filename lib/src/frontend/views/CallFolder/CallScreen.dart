
import 'package:chathub/src/controller/bloc/callBloc.dart';
import 'package:chathub/src/controller/models/call.dart';
import 'package:chathub/src/controller/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CallScreen extends StatelessWidget {
  final Call call;

  const CallScreen({Key key, @required this.call}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var callmethods = Provider.of<CallMethods>(context);
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              "Calls",
              style: TextStyles.loginButton,
            ),
          ),
          MaterialButton(
            color: Colors.red,
            child: Icon(
              Icons.call_end,
              color: Colors.white,
            ),
            onPressed: () {
              callmethods.endCall(call: call);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
