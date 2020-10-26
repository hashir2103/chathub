import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/frontend/widgets/AppButton.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool islogginPressed = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseServices _auth = Provider.of<FirebaseServices>(context);
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: AppButton(
              buttonType: ButtonType.login,
              buttonText: 'LOGIN',
              onPressed: () async {
                setState(() {
                  islogginPressed = true;
                });
                var user = await _auth.signIn();
                _auth.checkForNewUser(user.user).then((isNewUser) {
                  setState(() {
                    islogginPressed = false;
                  });
                  if (isNewUser == true) {
                    _auth.addUser(user).then((value) =>
                        Navigator.pushReplacementNamed(context, '/HomeScreen'));
                  } else {
                    Navigator.pushReplacementNamed(context, '/HomeScreen');
                  }
                });
              },
            ),
          ),
          islogginPressed
              ? Center(child: CircularProgressIndicator())
              : Container()
        ],
      ),
    );
  }
}
