import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/backend/routes.dart';
import 'package:chathub/src/controller/bloc/CallLogBloc.dart';
import 'package:chathub/src/controller/bloc/callBloc.dart';
import 'package:chathub/src/controller/bloc/chatBloc.dart';
import 'package:chathub/src/controller/bloc/searchbloc.dart';
import 'package:chathub/src/controller/bloc/userbloc.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/frontend/views/CallFolder/pickup_layout.dart';
import 'package:chathub/src/frontend/views/HomeScreen.dart';
import 'package:chathub/src/frontend/views/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  @override
  void initState() {
    user = _auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          Provider(create: (context) => FirebaseServices()),
          Provider(create: (context) => SearchBloc()),
          Provider(create: (context) => ChatBloc()),
          Provider(create: (context) => CallMethods()),
          Provider(create: (context) => LogBloc()),
        ],
        child: MaterialApp(
          theme: ThemeData(
              appBarTheme: AppBarTheme(color: AppColor.blackColor),
              scaffoldBackgroundColor: AppColor.blackColor),
          onGenerateRoute: Routes.materialPageRoute,
          debugShowCheckedModeBanner: false,
          home: PickupLayout(
            scaffold: Scaffold(
              body: (user == null) ? LoginScreen() : HomeScreen(),
            ),
          ),
        ));
  }
}
