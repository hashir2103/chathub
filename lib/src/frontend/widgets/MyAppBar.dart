import 'package:chathub/src/frontend/styles/baseStyle.dart';
import 'package:chathub/src/frontend/styles/colorsStyle.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget leading;
  final List<Widget> action;
  final Widget title;
  final bool centerTitle;

  const MyAppBar({
    Key key,
    this.title,  this.leading, this.action, this.centerTitle,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 25);
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: BaseStyle.appBarPadding),
        decoration: BoxDecoration(
          color: AppColor.blackColor,
            border: Border(
          bottom: BorderSide(width: 2, style: BorderStyle.solid),
        )),
        child: AppBar(
          backgroundColor: AppColor.blackColor,
          elevation: 0,
          leading: widget.leading,
          title: widget.title,
          actions: widget.action,
          centerTitle: widget.centerTitle,
        ));
  }
}
