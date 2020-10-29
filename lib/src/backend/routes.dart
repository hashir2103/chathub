import 'package:chathub/src/frontend/views/CallFolder/CallScreen.dart';
import 'package:chathub/src/frontend/views/CallFolder/callLogs.dart';
import 'package:chathub/src/frontend/views/Chatfolder/ChatScreen.dart';
import 'package:chathub/src/frontend/views/Chatfolder/chatmessage.dart';
import 'package:chathub/src/frontend/views/contactFolder/ContactScreen.dart';
import 'package:chathub/src/frontend/views/HomeScreen.dart';
import 'package:chathub/src/frontend/views/LoginScreen.dart';
import 'package:chathub/src/frontend/views/searchScreen.dart';
import 'package:chathub/src/frontend/widgets/ImageContainer.dart';
import 'package:flutter/material.dart';

abstract class Routes {
  static MaterialPageRoute materialPageRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/HomeScreen':
        return MaterialPageRoute(builder: (context) => HomeScreen());

      case '/login':
        return MaterialPageRoute(builder: (context) => LoginScreen());

      case '/chatscreen':
        return MaterialPageRoute(builder: (context) => ChatScreen());
      case '/callscreen':
        return MaterialPageRoute(builder: (context) => CallScreen(call: settings.arguments));
      case '/calllogs':
        return MaterialPageRoute(builder: (context) => CallLogs());
      case '/contactscreen':
        return MaterialPageRoute(builder: (context) => ContactScreen());
      case '/searchscreen':
        return MaterialPageRoute(builder: (context) => SearchScreen());
        
      case '/chatmessage':
        return MaterialPageRoute(builder: (context) => ChatMessage(receiver: settings.arguments,));
        
      case '/showimage':
        return MaterialPageRoute(builder: (context) => ShowImage(url: settings.arguments,));
        

      default:
        return MaterialPageRoute(builder: (context) => HomeScreen());
    }
  }
}
