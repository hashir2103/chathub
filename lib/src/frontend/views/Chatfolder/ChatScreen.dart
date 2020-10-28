import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/controller/bloc/searchbloc.dart';
import 'package:chathub/src/controller/models/ChatModel.dart';
import 'package:chathub/src/controller/models/userModel.dart';
import 'package:chathub/src/controller/styles/baseStyle.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/frontend/views/searchScreen.dart';
import 'package:chathub/src/frontend/widgets/MainAppBar.dart';
import 'package:chathub/src/frontend/widgets/AppTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  MyUser user;
  @override
  void initState() {
    var _db = Provider.of<FirebaseServices>(context, listen: false);
    setState(() {
      user = _db.currentUser;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var searchBloc = Provider.of<SearchBloc>(context);
    return StreamBuilder<bool>(
        initialData: false,
        stream: searchBloc.showSearchResult,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: AppColor.blackColor,
            appBar: AppAppBar(displayName: user.displayName ?? ' '),
            body: (!snapshot.hasData)
                ? chatContainer(user)
                : Stack(
                    children: [
                      chatContainer(user),
                      (snapshot.data) ? SearchScreen() : Container()
                    ],
                  ),
            floatingActionButton: (snapshot.data)
                ? Container()
                : FloatingActionButton(
                    elevation: 1,
                    backgroundColor: AppColor.separatorColor,
                    foregroundColor: AppColor.iconColors,
                    child: Icon(
                      Icons.edit,
                      size: BaseStyle.iconSize,
                    ),
                    // mini: true,
                    tooltip: "Start New Chat",
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(BaseStyle.borderRaduis))),
                    onPressed: () {}),
          );
        });
  }

  Widget chatContainer(MyUser user) {
    var chatdetails = chatdata;
    return Container(
        child: ListView.builder(
            itemCount: chatdetails.length,
            itemBuilder: (context, index) {
              var chat = chatdetails[index];
              return AppTile(
                onTap: () => Navigator.pushNamed(context, '/chatmessage',
                    arguments: user),
                name: chat.name,
                message: chat.message,
                time: chat.time,
                // avatarUrl: chat.avatarUrl
              );
            }));
  }
}
