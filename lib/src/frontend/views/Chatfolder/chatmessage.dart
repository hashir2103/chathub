import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/controller/bloc/chatBloc.dart';
import 'package:chathub/src/controller/bloc/searchbloc.dart';
import 'package:chathub/src/controller/models/message.dart';
import 'package:chathub/src/controller/models/userModel.dart';
import 'package:chathub/src/frontend/styles/baseStyle.dart';
import 'package:chathub/src/frontend/styles/colorsStyle.dart';
import 'package:chathub/src/frontend/styles/textstyle.dart';
import 'package:chathub/src/frontend/widgets/AppTextField.dart';
import 'package:chathub/src/frontend/widgets/ImageContainer.dart';
import 'package:chathub/src/frontend/widgets/MyAppBar.dart';
import 'package:chathub/src/frontend/widgets/messagecontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            prefixPressed: showOptions,
            suffixIcon: Icons.send,
            suffixPressed: sendMessage,
          ),
        ],
      ),
    );
  }

  showOptions() {
    var chatBloc = Provider.of<ChatBloc>(context, listen: false);
    showModalBottomSheet(
        backgroundColor: AppColor.blackColor,
        context: context,
        builder: (context) {
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
                                senderId: sender.uid,
                                recieverId: widget.receiver.uid,
                              );
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
                return(snapshot.data[index]['type']=='image')
                ? ImageContainer(receiver: widget.receiver,currentUser: sender,message:snapshot.data[index])
                : MessageContianer(
                    receiver: widget.receiver,
                    currentUser: sender,
                    message: snapshot.data[index]);
              });
        });
  }

  MyAppBar appBar(context, SearchBloc searchBloc) {
    return MyAppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColor.userCircleBackground,
            radius:BaseStyle.avatarRadius - 5,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            widget.receiver.displayName ?? ' ',
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
