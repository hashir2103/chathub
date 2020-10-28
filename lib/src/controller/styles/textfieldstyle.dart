import 'package:chathub/src/controller/styles/baseStyle.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:chathub/src/controller/styles/textstyle.dart';
import 'package:flutter/material.dart';

abstract class TextFieldStyle {
  static TextStyle get text => TextStyles.chatAppBarTitle;
  static Color get cursorColor => AppColor.darkblue;

  static TextStyle get placeHolder => TextStyles.suggestion;

  static TextAlign get textAlign => TextAlign.center;

  static Widget iconPrefix(IconData icon) => BaseStyle.iconPrefix(icon);

  static BoxDecoration get cupertinoDecoration {
    return BoxDecoration(
      border: Border.all(
          color: AppColor.separatorColor, width: BaseStyle.borderRaduis),
      borderRadius: BorderRadius.circular(BaseStyle.borderwidth),
    );
  }

  static BoxDecoration get cupertinoErrorDecoration {
    return BoxDecoration(
      border: Border.all(color: AppColor.red, width: BaseStyle.borderRaduis),
      borderRadius: BorderRadius.circular(BaseStyle.borderwidth),
    );
  }

  static InputDecoration materialDecoration(
      {String hintText, IconData icon, String errorText}) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(20),
      hintText: hintText,
      errorText: errorText,
      errorStyle: TextStyles.errorText,
      hintStyle: TextFieldStyle.placeHolder,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: AppColor.senderColor, width: BaseStyle.borderwidth),
        borderRadius: BorderRadius.circular(BaseStyle.borderRaduis),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: AppColor.separatorColor, width: BaseStyle.borderwidth),
        borderRadius: BorderRadius.circular(BaseStyle.borderRaduis),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: AppColor.separatorColor, width: BaseStyle.borderwidth),
        borderRadius: BorderRadius.circular(BaseStyle.borderRaduis),
      ),
      errorBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: AppColor.red, width: BaseStyle.borderwidth),
        borderRadius: BorderRadius.circular(BaseStyle.borderRaduis),
      ),
      prefixIcon: iconPrefix(icon),
    );
  }
}
