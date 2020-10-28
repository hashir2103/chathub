import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:flutter/material.dart';

abstract class BaseStyle {
  static double get borderRaduis => 25.0;
  static double get borderRaduisTextField => 15.0;
  static double get iconSize => 28.0;
  static double get avatarRadius => 30.0;
  static double get buttonPadding => 35.0;
  static double get appBarPadding => 10.0;

  static double get borderwidth => 0.0;
  static double get verticalPadding => 10.0;
  static double get horizontalPadding => 10.0;

  static Icon myIcon(IconData icon) {
    return Icon(
      icon,
      size: BaseStyle.iconSize,
      color: AppColor.iconColors,
    );
  }

  static EdgeInsets get textFieldPadding {
    return EdgeInsets.all(10);
  }

  static List<BoxShadow> get boxShadow {
    return [
      BoxShadow(
        color: AppColor.iconColors,
        offset: Offset(0, 0),
        blurRadius: 2,
      )
    ];
  }

  static Widget iconPrefix(IconData icon) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Icon(
        icon,
        size: 35.0,
        color: AppColor.separatorColor,
      ),
    );
  }
}
