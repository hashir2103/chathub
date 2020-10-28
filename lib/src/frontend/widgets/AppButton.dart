import 'package:chathub/src/controller/styles/baseStyle.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/controller/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppButton extends StatefulWidget {
  final ButtonType buttonType;
  final String buttonText;
  final Function onPressed;

  const AppButton({Key key, this.buttonType, this.buttonText, this.onPressed})
      : super(key: key);
  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    switch (widget.buttonType) {
      case ButtonType.login:
        return Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: AppColor.separatorColor,
          child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(BaseStyle.borderRaduis)),
              padding: EdgeInsets.all(BaseStyle.buttonPadding),
              onPressed: widget.onPressed,
              child: Text(
                widget.buttonText,
                style: TextStyles.loginButton,
              )),
        );
        break;
      default:
        return FlatButton(
            padding: EdgeInsets.all(BaseStyle.buttonPadding),
            onPressed: widget.onPressed,
            child: Text(
              widget.buttonText,
              style: TextStyles.loginButton,
            ));
    }
  }
}

enum ButtonType { normal, login, DarkGray, DarkBlue, Disable }
