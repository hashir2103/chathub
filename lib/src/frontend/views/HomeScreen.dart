import 'package:chathub/src/controller/styles/baseStyle.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/frontend/views/CallFolder/callLogs.dart';
import 'package:chathub/src/frontend/views/CallFolder/pickup_layout.dart';
import 'package:chathub/src/frontend/views/Chatfolder/ChatScreen.dart';
import 'package:chathub/src/frontend/views/contactFolder/ContactScreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget currentWidget = ChatScreen();
  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        body: currentWidget,
        backgroundColor: AppColor.blackColor,
        bottomNavigationBar: CurvedNavigationBar(
          color: AppColor.blackColor,
          backgroundColor: AppColor.separatorColor,
          buttonBackgroundColor: AppColor.separatorColor,
          animationDuration: Duration(milliseconds: 400),
          animationCurve: Curves.easeInOutQuad,
          index: 1,
          items: <Widget>[
            Icon(
              Icons.call,
              size: BaseStyle.iconSize,
              color: AppColor.iconColors,
            ),
            Icon(
              Icons.chat,
              size: BaseStyle.iconSize,
              color: AppColor.iconColors,
            ),
            Icon(
              Icons.contacts,
              size: BaseStyle.iconSize,
              color: AppColor.iconColors,
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                setState(() {
                  currentWidget = CallLogs(); 
                });
                break;
              case 1:
                setState(() {
                  currentWidget = ChatScreen();
                });
                break;
              case 2:
                setState(() {
                  currentWidget = ContactScreen();
                });
                break;
              default:
                currentWidget = ChatScreen();
                break;
            }
          },
        ),
      ),
    );
  }
}
