import 'package:chathub/src/controller/bloc/chatBloc.dart';
import 'package:chathub/src/controller/bloc/searchbloc.dart';
import 'package:chathub/src/controller/bloc/userbloc.dart';
import 'package:chathub/src/controller/models/contactModel.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/controller/styles/textstyle.dart';
import 'package:chathub/src/frontend/views/CallFolder/pickup_layout.dart';
import 'package:chathub/src/frontend/views/searchScreen.dart';
import 'package:chathub/src/frontend/widgets/MainAppBar.dart';
import 'package:chathub/src/frontend/widgets/contactview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var searchBloc = Provider.of<SearchBloc>(context);
    return StreamBuilder<bool>(
        initialData: false,
        stream: searchBloc.showSearchResult,
        builder: (context, snapshot) {
          return PickupLayout(
            scaffold: Scaffold(
              backgroundColor: AppColor.blackColor,
              appBar: AppAppBar(),
              body: (!snapshot.hasData)
                  ? chatContainer(context)
                  : Stack(
                      children: [
                        chatContainer(context),
                        (snapshot.data) ? SearchScreen() : Container()
                      ],
                    ),
              // floatingActionButton: (snapshot.data)
              //     ? Container()
              //     : FloatingActionButton(
              //         elevation: 1,
              //         backgroundColor: AppColor.separatorColor,
              //         foregroundColor: AppColor.iconColors,
              //         child: Icon(
              //           Icons.edit,
              //           size: BaseStyle.iconSize,
              //         ),
              //         // mini: true,
              //         tooltip: "Start New Chat",
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.all(
              //                 Radius.circular(BaseStyle.borderRaduis))),
              //         onPressed: () {}),
            ),
          );
        });
  }

  Widget chatContainer(context) {

    var chatBloc = Provider.of<ChatBloc>(context);
    var user = Provider.of<UserProvider>(context);
    var userId = user.getUserId;
    return StreamBuilder<QuerySnapshot>(
        stream: chatBloc.fetchContact(userId: userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          else {
            var docList = snapshot.data.docs;
            if (docList.isEmpty) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    "Search for your friends and family to start calling or chatting with them..",
                    style: TextStyles.suggestion,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return ListView.builder(
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data());
                  return ContactView(contact: contact);
                });
          }
        });
  }
}
