import 'dart:math';

import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/controller/bloc/callBloc.dart';
import 'package:chathub/src/controller/bloc/chatBloc.dart';
import 'package:chathub/src/controller/bloc/searchbloc.dart';
import 'package:chathub/src/controller/bloc/userbloc.dart';
import 'package:chathub/src/controller/models/messageModel.dart';
import 'package:chathub/src/controller/models/userModel.dart';
import 'package:chathub/src/controller/styles/baseStyle.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/controller/styles/textstyle.dart';
import 'package:chathub/src/controller/utils/premissions.dart';
import 'package:chathub/src/frontend/views/CallFolder/pickup_layout.dart';
import 'package:chathub/src/frontend/widgets/AppTextField.dart';
import 'package:chathub/src/frontend/widgets/ImageContainer.dart';
import 'package:chathub/src/frontend/widgets/MyAppBar.dart';
import 'package:chathub/src/frontend/widgets/messagecontainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatefulWidget {
  final MyUser receiver;
  ChatMessage({Key key, @required this.receiver}) : super(key: key);

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  FirebaseServices _db;
  User sender;
  FocusNode focusNode;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     _db = Provider.of<FirebaseServices>(context);
    var searchBloc = Provider.of<SearchBloc>(context);
    var callMethods = Provider.of<CallMethods>(context);
    var user = Provider.of<UserProvider>(context);
    setState(() {
      sender = user.getUser;
    });
    return PickupLayout(
      scaffold: Scaffold(
        appBar: appBar(context, searchBloc, callMethods),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(child: messageList()),
            textBoxAndIcon()
          ],
        ),
      ),
    );
  }

  showOptions() {
    var chatBloc = Provider.of<ChatBloc>(context, listen: false);
    showModalBottomSheet(
        backgroundColor: AppColor.blackColor,
        context: context,
        builder: (context) {
          FocusScope.of(context).unfocus();
          return Container(
            color: AppColor.separatorColor,
            child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                margin: EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
                // height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                    color: AppColor.separatorColor,
                    borderRadius: BorderRadius.only(
                        // topLeft: Radius.circular(BaseStyle.borderRaduis),
                        // topRight: Radius.circular(BaseStyle.borderRaduis),
                        )),
                child: GridView(
                  // padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.05),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundColor: AppColor.blueColor,
                        radius: BaseStyle.avatarRadius,
                        child: IconButton(
                            icon: BaseStyle.myIcon(Icons.camera_alt),
                            onPressed: () {
                              chatBloc.pickImage(
                                ImageSource.camera,
                                senderId: sender,
                                recieverId: widget.receiver.uid,
                              );
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).pop();
                            }),
                      ),
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: AppColor.red,
                        radius: BaseStyle.avatarRadius,
                        child: IconButton(
                            icon: BaseStyle.myIcon(Icons.perm_media),
                            onPressed: () {
                              chatBloc.pickImage(
                                ImageSource.gallery,
                                senderId: sender.uid,
                                recieverId: widget.receiver.uid,
                              );
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).pop();
                            }),
                      ),
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.green.withOpacity(0.5),
                        radius: BaseStyle.avatarRadius,
                        child: IconButton(
                            icon: BaseStyle.myIcon(Icons.location_on),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).pop();
                            }),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      var timestamp = DateTime.now().toIso8601String();
      var time = timestamp.split('T')[1].substring(0, 5);
      Message message = Message(
          receiverId: widget.receiver.uid,
          senderId: sender.uid,
          message: _controller.text.trim(),
          time: time,
          timestamp: timestamp);

      _db.addMessageToDb(message, sender, widget.receiver);
      _controller.clear();
    }
  }

  Widget messageList() {
    return Container(
      child: StreamBuilder<List<Map>>(
          stream: _db.messageList(sender, widget.receiver),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return ListView.builder(
                reverse: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return (snapshot.data[index]['type'] == 'image')
                      ? ImageContainer(
                          receiver: widget.receiver,
                          currentUser: sender,
                          message: snapshot.data[index])
                      : MessageContianer(
                          receiver: widget.receiver,
                          currentUser: sender,
                          message: snapshot.data[index]);
                });
          }),
    );
  }

  Widget textBoxAndIcon() {
    return Container(
      margin: EdgeInsets.all(7),
      decoration: BoxDecoration(
          // boxShadow: kElevationToShadow[2],
          border: Border.all(color: AppColor.iconColors, width: 1),
          borderRadius: BorderRadius.circular(20)),
      height: 70,
      child: Stack(
        children: [
          AppTextField(
            focusNode: focusNode,
            controller: _controller,
            textInputType: TextInputType.multiline,
            hintText: "Type Message..",
          ),
          Container(
            margin: EdgeInsets.only(left: 7),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                  onTap: showOptions,
                  child: CircleAvatar(
                      backgroundColor: AppColor.darkblue,
                      child: Transform.rotate(
                          angle: -pi / 4,
                          child: BaseStyle.myIcon(Icons.attach_file)))),
              // )
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 7),
            child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: sendMessage,
                    child: CircleAvatar(
                        backgroundColor: AppColor.blueColor.withOpacity(0.5),
                        child: Transform.rotate(
                            angle: 0, child: BaseStyle.myIcon(Icons.send))))),
          )
        ],
      ),
    );
  }

  MyAppBar appBar(context, SearchBloc searchBloc, CallMethods callMethods) {
    return MyAppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColor.userCircleBackground,
            backgroundImage: NetworkImage(widget.receiver.photoUrl),
            radius: BaseStyle.avatarRadius - 5,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            widget.receiver.displayName ?? ' ',
            style: TextStyles.chatAppBarTitle,
            overflow: TextOverflow.fade,
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
            onPressed: () async =>
                await Permissions.cameraAndMicrophonePermissionsGranted()
                    ? callMethods.dial(
                        from: sender, to: widget.receiver, context: context)
                    : {}),
        IconButton(
            color: AppColor.iconColors,
            iconSize: BaseStyle.iconSize,
            icon: Icon(Icons.call),
            onPressed: () {})
      ],
    );
  }
}
