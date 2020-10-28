import 'package:chathub/src/frontend/styles/textstyle.dart';
import 'package:flutter/material.dart';

class CallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Calls",style: TextStyles.loginButton,),),
    );
  }
}