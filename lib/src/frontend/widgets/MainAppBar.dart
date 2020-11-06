import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/controller/bloc/chatBloc.dart';
import 'package:chathub/src/controller/bloc/searchbloc.dart';
import 'package:chathub/src/controller/bloc/userbloc.dart';
import 'package:chathub/src/controller/styles/baseStyle.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/frontend/widgets/AnimatedSearchBar.dart';
import 'package:chathub/src/frontend/widgets/userDetailContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cachedNetworkImage.dart';

class AppAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 25);
  @override
  _AppAppBarState createState() => _AppAppBarState();
}

class _AppAppBarState extends State<AppAppBar> {
  @override
  Widget build(BuildContext context) {
    var searchBloc = Provider.of<SearchBloc>(context);
    final user = Provider.of<UserProvider>(context);
    var db = Provider.of<FirebaseServices>(context);
    var chatBloc = Provider.of<ChatBloc>(context);
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
                bottom: BorderSide(
                    width: 0.5,
                    style: BorderStyle.solid,
                    color: AppColor.dividerColor),
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
                      title: GestureDetector(
                        onTap: () => userProfile(context),
                        child: Align(
                          alignment: Alignment.center,
                          child: StreamBuilder<String>(
                              initialData: user.getPhotoURL,
                              stream: chatBloc.editImg,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CachedImage(
                                  user.getPhotoURL,
                                  isRound: true,
                                  radius: BaseStyle.avatarRadius+ 25,
                                );
                                }
                                return CachedImage(
                                  snapshot.data,
                                  isRound: true,
                                  radius: BaseStyle.avatarRadius+25,
                                );
                              }),
                        ),
                      ),
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
                        // IconButton(
                        //     color: AppColor.iconColors,
                        //     icon: Icon(
                        //       Icons.more_vert,
                        //       color: AppColor.iconColors,
                        //       size: BaseStyle.iconSize,
                        //     ),
                        //     onPressed: () {}),
                      ],
                      centerTitle: true,
                    )
                  : WillPopScope(
                      child: AnimatedSearchBar(),
                      onWillPop: () => searchBloc.changeFoldSearchBar(true)));
        });
  }

  userProfile(context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: AppColor.blackColor,
        isScrollControlled: true,
        builder: (context) =>
            SingleChildScrollView(child: UserDetailContainer()));
  }
}
