import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/controller/bloc/userbloc.dart';
import 'package:chathub/src/controller/styles/baseStyle.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/controller/utils/userstate.dart';
import 'package:chathub/src/frontend/views/CallFolder/callLogs.dart';
import 'package:chathub/src/frontend/views/CallFolder/pickup_layout.dart';
import 'package:chathub/src/frontend/views/Chatfolder/ChatScreen.dart';
import 'package:chathub/src/frontend/views/contactFolder/ContactScreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Widget currentWidget = ChatScreen();
  UserProvider userProvider;
  final _auth = FirebaseServices();
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();
      _auth.setUserState(
          userId: userProvider.getUserId, userState: UserState.Online);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String userId = userProvider.getUserId;
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        userId != null
            ? _auth.setUserState(userId: userId, userState: UserState.Online)
            : print('resumed state');
        break;
      case AppLifecycleState.inactive:
        userId != null
            ? _auth.setUserState(userId: userId, userState: UserState.Offline)
            : print('inactive state');
        break;
      case AppLifecycleState.paused:
        userId != null
            ? _auth.setUserState(userId: userId, userState: UserState.Offline)
            : print('paused state');
        break;
      case AppLifecycleState.detached:
        userId != null
            ? _auth.setUserState(userId: userId, userState: UserState.Offline)
            : print('detached state');
        break;
      default:
    }
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
