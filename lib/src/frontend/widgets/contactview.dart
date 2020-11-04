import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/controller/bloc/chatBloc.dart';
import 'package:chathub/src/controller/bloc/userbloc.dart';
import 'package:chathub/src/controller/models/contactModel.dart';
import 'package:chathub/src/controller/models/userModel.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/frontend/widgets/lastmessageContainer.dart';
import 'package:chathub/src/frontend/widgets/onlinedotIndicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cachedNetworkImage.dart';

class ContactView extends StatelessWidget {
  final Contact contact;

  ContactView({@required this.contact});

  @override
  Widget build(BuildContext context) {
    var _db = Provider.of<FirebaseServices>(context);
    return FutureBuilder<MyUser>(
      future: _db.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        MyUser user = snapshot.data;
        return ViewLayout(
          contact: user,
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final MyUser contact;

  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final chatBloc = Provider.of<ChatBloc>(context);

    return Column(
      children: [
        ListTile(
          onTap: () =>
              Navigator.pushNamed(context, '/chatmessage', arguments: contact),
          title: Text(
            (contact != null ? contact.displayName : null) != null
                ? contact.displayName
                : "..",
            style: TextStyle(
                color: Colors.white, fontFamily: "Arial", fontSize: 19),
          ),
          subtitle: LastMessageContainer(
            stream: chatBloc.fetchLastMessageBetween(
              senderId: userProvider.getUser.uid,
              recieverId: contact.uid,
            ),
          ),
          leading: Container(
            constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
            child: Stack(
              children: <Widget>[
                CachedImage(
                  contact.photoUrl,
                  radius: 70,
                  isRound: true,
                ),
                OnlineDotIndicator(
                  uid: contact.uid,
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 0.5,
          color: AppColor.dividerColor,
        )
      ],
    );
  }
}
