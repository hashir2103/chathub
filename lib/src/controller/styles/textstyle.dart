import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TextStyles {
  static TextStyle get loginButton {
    return GoogleFonts.economica(
        textStyle: TextStyle(
            letterSpacing: 1.5,
            color: Colors.white,
            fontSize: 40.0,
            fontWeight: FontWeight.bold));
  }

  static TextStyle get appTileTitle {
    return GoogleFonts.poppins(
        textStyle:
            TextStyle(color: AppColor.iconColors, fontWeight: FontWeight.bold));
  }

  static TextStyle get appTileSubtilte {
    return TextStyle(
      color: Colors.grey,
      fontSize: 16.0,
    );
  }

  static TextStyle get chatAppBarTitle {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: Colors.white, fontSize: 18.0));
  }

  static TextStyle get message {
    return GoogleFonts.roboto(
        textStyle:
            TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 20.0));
  }

  static TextStyle get picker {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColor.separatorColor, fontSize: 35.0));
  }

  static TextStyle get suggestion {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColor.separatorColor, fontSize: 20.0));
  }

  static TextStyle get errorText {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColor.red, fontSize: 12.0));
  }

  static TextStyle get smallText {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColor.iconColors, fontSize: 12.0));
  }
}
