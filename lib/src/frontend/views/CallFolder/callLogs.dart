import 'package:chathub/src/controller/bloc/CallLogBloc.dart';
import 'package:chathub/src/controller/models/CallLog.dart';
import 'package:chathub/src/controller/styles/textstyle.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class CallLogs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var log = Provider.of<LogBloc>(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          LogBloc.init(ishive: false);
          LogBloc.addLogs(Log());
        },
        child: Center(
          child: Text(
            "Call Logs",
            style: TextStyles.loginButton,
          ),
        ),
      ),
    );
  }
}
