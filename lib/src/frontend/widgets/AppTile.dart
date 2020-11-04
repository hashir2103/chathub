import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/controller/styles/textstyle.dart';
import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final Function onTap;

  const AppTile(
      {Key key,
      this.onTap,
      @required this.name,
      this.message = '',
      this.time = '',
      this.avatarUrl = ''})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            radius: 25,
            foregroundColor: AppColor.separatorColor,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(avatarUrl)
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                name,
                style: TextStyles.appTileTitle,
              ),
              Text(
                time,
                style: TextStyles.appTileTitle,
              ),
            ],
          ),
          subtitle: Container(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(message, style: TextStyles.appTileSubtilte)),
        ),
        Divider(
          thickness: 0.5,
          color: AppColor.dividerColor,
        )
      ],
    );
  }
}
