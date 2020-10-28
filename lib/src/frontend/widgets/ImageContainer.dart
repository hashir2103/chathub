import 'package:chathub/src/controller/models/userModel.dart';
// ignore: unused_import
import 'package:chathub/src/frontend/styles/colorsStyle.dart';
import 'package:chathub/src/frontend/styles/textstyle.dart';
import 'package:chathub/src/frontend/widgets/cachedNetworkImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatefulWidget {
  final MyUser currentUser;
  final MyUser receiver;
  final Map message;

  const ImageContainer({Key key, this.message, this.currentUser, this.receiver})
      : super(key: key);

  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
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
        " ";
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentUser.uid.trim() == widget.message['senderId'].trim()) {
      setState(() {
        sender = true;
      });
      return Align(
          alignment: Alignment.centerRight,
          child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.60),
              margin: EdgeInsets.only(bottom: 12, left: 7, right: 7),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/showimage',
                          arguments: widget.message['photoUrl']),
                      child: Container(
                        child: CachedImage(url:widget.message['photoUrl']) ??
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                      )),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      time ?? '',
                      style: TextStyles.smallText,
                    ),
                  )
                ],
              )));
    }
    setState(() {
      sender = false;
    });
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.60),
          margin: EdgeInsets.only(bottom: 12, left: 7, right: 7),
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/showimage',
                    arguments: widget.message['photoUrl']),
                child: Container(
                    child: CachedImage(url: widget.message['photoUrl']) ??
                        Center(child: CircularProgressIndicator())),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  time ?? '',
                  style: TextStyles.smallText,
                ),
              )
            ],
          )),
    );
  }
}

class ShowImage extends StatelessWidget {
  final String url;

  const ShowImage({Key key, @required this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MyAppBar(),
      body: Center(
        child: (url.isEmpty) ? CircularProgressIndicator() : CachedImage(url:url),
      ),
    );
  }
}
