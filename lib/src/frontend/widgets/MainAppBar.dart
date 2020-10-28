import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/controller/bloc/searchbloc.dart';
import 'package:chathub/src/controller/styles/baseStyle.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/controller/styles/textstyle.dart';
import 'package:chathub/src/frontend/widgets/AnimatedSearchBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String displayName;
  const AppAppBar({
    Key key,
    @required this.displayName,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 25);
  @override
  _AppAppBarState createState() => _AppAppBarState();
}

class _AppAppBarState extends State<AppAppBar> {
  @override
  Widget build(BuildContext context) {
    var searchBloc = Provider.of<SearchBloc>(context);
    var db = Provider.of<FirebaseServices>(context);
    return StreamBuilder<bool>(
        stream: searchBloc.foldSearchBar,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          bool folded = snapshot.data;
          return Container(
              alignment: (folded) ? Alignment.center : Alignment.bottomRight,
              padding: EdgeInsets.all(BaseStyle.appBarPadding),
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 1.4, style: BorderStyle.solid),
              )),
              child: (folded)
                  ? AppBar(
                      backgroundColor: AppColor.blackColor,
                      elevation: 0,
                      leading: IconButton(
                          icon: Icon(
                            Icons.notifications,
                            color: AppColor.iconColors,
                            size: BaseStyle.iconSize,
                          ),
                          onPressed: () {
                            db.logout();
                            Navigator.pushReplacementNamed(context, '/login');
                          }),
                      title: Stack(children: [
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                              radius: 25,
                              backgroundColor: AppColor.separatorColor,
                              child: Text(widget.displayName[0] ?? " ",
                                  style: TextStyles.chatAppBarTitle)),
                        ),
                      ]),
                      actions: [
                        IconButton(
                            color: AppColor.iconColors,
                            icon: Icon(
                              Icons.search,
                              color: AppColor.iconColors,
                              size: BaseStyle.iconSize,
                            ),
                            onPressed: () {
                              searchBloc.changeFoldSearchBar(false);
                            }),
                        IconButton(
                            color: AppColor.iconColors,
                            icon: Icon(
                              Icons.more_vert,
                              color: AppColor.iconColors,
                              size: BaseStyle.iconSize,
                            ),
                            onPressed: () {}),
                      ],
                      centerTitle: true,
                    )
                  : WillPopScope(
                      child: AnimatedSearchBar(),
                      onWillPop: () => searchBloc.changeFoldSearchBar(true)));
        });
  }
}
