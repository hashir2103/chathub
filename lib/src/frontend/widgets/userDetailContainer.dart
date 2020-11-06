import 'package:chathub/src/backend/firebase_services.dart';
import 'package:chathub/src/controller/bloc/chatBloc.dart';
import 'package:chathub/src/controller/bloc/userbloc.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/controller/styles/textstyle.dart';
import 'package:chathub/src/frontend/widgets/AppTextField.dart';
import 'package:chathub/src/frontend/widgets/cachedNetworkImage.dart';
import 'package:chathub/src/frontend/widgets/onlinedotIndicator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserDetailContainer extends StatefulWidget {
  @override
  _UserDetailContainerState createState() => _UserDetailContainerState();
}

class _UserDetailContainerState extends State<UserDetailContainer> {
  TextEditingController _controller;
  FocusNode _node = FocusNode();
  UserProvider user;
  ChatBloc chatBloc;

  @override
  void dispose() {
    _node.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    chatBloc = Provider.of<ChatBloc>(context);
    var db = Provider.of<FirebaseServices>(context);

    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              StreamBuilder<String>(
                  initialData: user.getPhotoURL,
                  stream: chatBloc.editImg,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                        height: MediaQuery.of(context).size.height * .4,
                      );
                    return CachedImage(
                      snapshot.data,
                      height: MediaQuery.of(context).size.height * .4,
                      width: MediaQuery.of(context).size.height,
                    );
                  }),
              Positioned(
                  bottom: 15,
                  left: 15,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StreamBuilder<String>(
                          initialData: user.getUserName,
                          stream: chatBloc.displayName,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text(
                                user.getUserName,
                                style: TextStyles.loginButton,
                              );
                            }
                            return Text(
                              snapshot.data,
                              style: TextStyles.loginButton,
                            );
                          }),
                      SizedBox(
                        width: 2,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          OnlineDotIndicator(uid: user.getUserId),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
              height: 60,
              minWidth: double.infinity,
              color: AppColor.onlineDotColor.withOpacity(0.5),
              child: Text(
                "Change Display Name",
                style: TextStyles.profileButton,
              ),
              onPressed: () async {
                _showMyDialog();
              }),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
              height: 60,
              minWidth: double.infinity,
              color: AppColor.blueColor,
              child: Text(
                "Edit Profile Photo",
                style: TextStyles.profileButton,
              ),
              onPressed: () async {
                await chatBloc.editImage(ImageSource.gallery, user.getUserId);
                await user.refreshUser();
              }),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
              height: 60,
              minWidth: double.infinity,
              color: AppColor.red,
              child: Text(
                "Logout",
                style: TextStyles.profileButton,
              ),
              onPressed: () {
                db.logout();
                Navigator.pushReplacementNamed(context, '/login');
              }),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void _showMyDialog() {
    // _node.requestFocus();
    String errorMsg = '';
    _controller = TextEditingController();
    _controller.text = user.getUserName;
    var alertDialog = AlertDialog(
      backgroundColor: AppColor.blackColor,
      title: Center(
          child: Text(
        'Change Display Name',
        style: TextStyles.appTileSubtilte,
      )),
      content: Container(
        margin: EdgeInsets.all(7),
        decoration: BoxDecoration(
            color: AppColor.blackColor.withOpacity(0.5),
            border: Border.all(color: AppColor.iconColors, width: 1),
            borderRadius: BorderRadius.circular(20)),
        child: AppTextField(
          focusNode: _node,
          controller: _controller,
          errorText: errorMsg,
          // hintText: user.getUserName
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('save'),
          onPressed: () async {
            if (_controller.text.length < 20) {
              await chatBloc.changeDisplayName(_controller.text.trim());
              await chatBloc.editDisplayName(
                  user.getUserId, _controller.text.trim());
              await user.refreshUser();
              Navigator.of(context).pop();
              setState(() {
                _controller.text = _controller.text.trim();
              });
            } else {
              setState(() {
                errorMsg = 'Must be less than 20 char';
              });
            }
          },
        ),
      ],
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }
}
