import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/backend/routes.dart';
import 'package:chathub/src/controller/bloc/callBloc.dart';
import 'package:chathub/src/controller/bloc/chatBloc.dart';
import 'package:chathub/src/controller/bloc/searchbloc.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/frontend/views/HomeScreen.dart';
import 'package:chathub/src/frontend/views/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseServices _auth = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (context) => FirebaseServices()),
          Provider(create: (context) => SearchBloc()),
          Provider(create: (context) => ChatBloc()),
          Provider(create: (context) => CallMethods()),
        ],
        child: MaterialApp(
          theme: ThemeData(
              appBarTheme: AppBarTheme(color: AppColor.blackColor),
              scaffoldBackgroundColor: AppColor.blackColor),
          onGenerateRoute: Routes.materialPageRoute,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: (_auth.currentUser.email.isEmpty)
                ? LoginScreen()
                : HomeScreen(),
          ),
        ));
  }
}
