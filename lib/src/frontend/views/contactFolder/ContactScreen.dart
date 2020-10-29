import 'package:chathub/src/controller/styles/textstyle.dart';
import 'package:chathub/src/frontend/views/CallFolder/pickup_layout.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        body: Center(
          child: Text(
            "Contacts List on this Screen!",
            style: TextStyles.loginButton,
          ),
        ),
      ),
    );
  }
}
