import 'package:chathub/src/frontend/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Contacts",style: TextStyles.loginButton,),),
    );
  }
}