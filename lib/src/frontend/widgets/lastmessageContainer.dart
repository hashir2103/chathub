import 'package:chathub/src/controller/models/messageModel.dart';
import 'package:chathub/src/controller/styles/textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LastMessageContainer extends StatelessWidget {
  final stream;

  LastMessageContainer({
    @required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data.docs;

          if (docList.isNotEmpty) {
            Message message = Message.fromFirebase(docList.last.data());
            return SizedBox(
              // width: MediaQuery.of(context).size.width * 0.6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width*0.6
                    ),
                    child: Text(message.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.appTileSubtilte),
                  ),
                  Text(
                    message.time,
                    style: TextStyles.appTileSubtilte,
                  ),
                ],
              ),
            );
          }

          return Text(
            "No Message",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          );
        }
        return Text(
          "..",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        );
      },
    );
  }
}
