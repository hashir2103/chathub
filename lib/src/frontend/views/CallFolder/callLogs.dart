import 'package:chathub/src/controller/styles/textstyle.dart';
import 'package:flutter/material.dart';

class CallLogs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Call Logs",
          style: TextStyles.loginButton,
        ),
      ),
    );
  }
}
