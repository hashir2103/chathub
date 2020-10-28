import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/controller/bloc/searchbloc.dart';
import 'package:chathub/src/controller/models/userModel.dart';
import 'package:chathub/src/controller/styles/baseStyle.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/controller/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key key,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<MyUser> userResult = [];
  @override
  void initState() {
    super.initState();
    var _db = Provider.of<FirebaseServices>(context, listen: false);
    if (userResult.isEmpty) {
      _db.fetchAllUsers().then((value) {
        setState(() {
          userResult = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var searchBloc = Provider.of<SearchBloc>(context);
    double width = MediaQuery.of(context).size.width / 15;
    double height = MediaQuery.of(context).size.width / 1.5;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: width),
        height: height,
        decoration: BoxDecoration(
          color: AppColor.blackColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(BaseStyle.borderRaduis),
            bottomRight: Radius.circular(BaseStyle.borderRaduis),
            topLeft: Radius.circular(BaseStyle.borderRaduis),
            topRight: Radius.circular(BaseStyle.borderRaduis),
          ),
          boxShadow: BaseStyle.boxShadow,
        ),
        child: (userResult.isEmpty)
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: AppColor.iconColors,
              ))
            : StreamBuilder<String>(
                stream: searchBloc.query,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: AppColor.iconColors,
                      ),
                    );
                  List<MyUser> fliteruser = [];
                  if (userResult.isNotEmpty) {
                    for (var user in userResult) {
                      if (user.displayName
                              .toLowerCase()
                              .contains(snapshot.data) ||
                          user.email.toLowerCase().contains(snapshot.data)) {
                        fliteruser.add(user);
                      }
                    }
                  }
                  return ListView.builder(
                      itemCount: fliteruser.length,
                      itemBuilder: (context, index) {
                        var userInfo = fliteruser[index];
                        return ListTile(
                          onTap: () => Navigator.pushReplacementNamed(
                              context, '/chatmessage',
                              arguments: userInfo),
                          leading: CircleAvatar(
                            // backgroundImage: NetworkImage(userInfo.photoUrl),
                            backgroundColor: AppColor.separatorColor,
                            child: Text('${index + 1}'),
                          ),
                          subtitle: Text(
                            userInfo.email ?? ' ',
                            style: TextStyles.appTileSubtilte,
                          ),
                          title: Text(
                            userInfo.displayName ?? ' ',
                            style: TextStyles.appTileTitle,
                          ),
                        );
                      });
                }));
  }
}
