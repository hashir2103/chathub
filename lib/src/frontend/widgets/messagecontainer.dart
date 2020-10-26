import 'package:chathub/src/controller/models/userModel.dart';
import 'package:chathub/src/frontend/styles/colorsStyle.dart';
import 'package:chathub/src/frontend/styles/textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageContianer extends StatefulWidget {
  final MyUser currentUser;
  final Map message;

  const MessageContianer({Key key, this.message, this.currentUser})
      : super(key: key);

  @override
  _MessageContianerState createState() => _MessageContianerState();
}

class _MessageContianerState extends State<MessageContianer> {
  bool sender;
  String time;
  @override
  void initState() {
    super.initState();
    time = (widget.message['timestamp'] as Timestamp)
            .toDate()
            .toString()
            .split(' ')[1]
            .split('.')[0]
            .substring(0, 5) ??
        "";
    if (widget.message['senderId'] == widget.currentUser.uid) {
      sender = true;
    } else {
      sender = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: (sender) ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.60),
          margin: EdgeInsets.only(bottom: 12, left: 7, right: 7),
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight:
                    (sender) ? Radius.circular(25) : Radius.circular(0),
                bottomLeft: (sender) ? Radius.circular(0) : Radius.circular(25),
                topLeft: (sender) ? Radius.circular(20) : Radius.circular(0),
                topRight: (sender) ? Radius.circular(0) : Radius.circular(20),
              ),
              border: Border.all(width: 2.5, color: AppColor.separatorColor)),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message['message'],
                  // overflow:TextOverflow.visible,
                  style: TextStyles.message,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  time ?? "",
                  style: TextStyles.smallText,
                ),
                
              ],
            ),
          )),
    );
  }
}
