import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/controller/bloc/searchbloc.dart';
import 'package:chathub/src/controller/models/message.dart';
import 'package:chathub/src/controller/models/userModel.dart';
import 'package:chathub/src/frontend/styles/baseStyle.dart';
import 'package:chathub/src/frontend/styles/colorsStyle.dart';
import 'package:chathub/src/frontend/styles/textstyle.dart';
import 'package:chathub/src/frontend/widgets/AppTextField.dart';
import 'package:chathub/src/frontend/widgets/MyAppBar.dart';
import 'package:chathub/src/frontend/widgets/messagecontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatefulWidget {
  final MyUser receiver;
  ChatMessage({Key key, @required this.receiver}) : super(key: key);

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  MyUser sender;
  FirebaseServices _db;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _db = Provider.of<FirebaseServices>(context, listen: false);
    sender = _db.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var searchBloc = Provider.of<SearchBloc>(context);
    sender = _db.currentUser;
    return Scaffold(
      appBar: appBar(context, searchBloc),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(child: messageList()),
          AppTextField(
            controller: _controller,
            textInputType: TextInputType.multiline,
            hintText: "Type Message..",
            prefixIcon: Icons.photo_camera,
            suffixIcon: Icons.send,
            suffixPressed: sendMessage,
          ),
        ],
      ),
    );
  }

  sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      Message message = Message(
          receiverId: widget.receiver.uid,
          senderId: sender.uid,
          message: _controller.text.trim(),
          timestamp: FieldValue.serverTimestamp());

      _db.addMessageToDb(message, sender, widget.receiver);
      _controller.clear();
    }
  }

  Widget messageList() {
    return StreamBuilder<List<Map>>(
        stream: _db.messageList(sender, widget.receiver),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          return ListView.builder(
              reverse: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return MessageContianer(
                    currentUser: sender, message: snapshot.data[index]);
              });
        });
  }

  appBar(context, SearchBloc searchBloc) {
    return MyAppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColor.userCircleBackground,
            radius: BaseStyle.avatarRadius,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            widget.receiver.displayName,
            style: TextStyles.chatAppBarTitle,
          ),
        ],
      ),
      leading: IconButton(
        color: AppColor.iconColors,
        iconSize: BaseStyle.iconSize,
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          searchBloc.changeShowSearchResult(false);
          Navigator.pushReplacementNamed(context, '/HomeScreen');
        },
      ),
      action: [
        IconButton(
            color: AppColor.iconColors,
            iconSize: BaseStyle.iconSize,
            icon: Icon(Icons.video_call),
            onPressed: () {}),
        IconButton(
            color: AppColor.iconColors,
            iconSize: BaseStyle.iconSize,
            icon: Icon(Icons.call),
            onPressed: () {})
      ],
    );
  }
}
