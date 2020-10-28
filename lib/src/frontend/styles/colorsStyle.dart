import 'package:flutter/material.dart';

abstract class AppColor {
  static Color get red => const Color(0xFFee5253);
  static Color get blueColor => const Color(0xff2b9ed4);
  static Color get darkblue => const Color(0xFF263a44);
  static Color get darkgray => const Color(0xFF4e5b60);
  // static Color get lightgray => const Color(0xFFca8d6ef);
  // static Color get lightblue => const Color(0xFF48a1af);
  // static Color get straw => const Color(0xFFe2a84b);
  // static Color get lightblue20 => AppColor.blueColor.withOpacity(0.2);
  // static Color get green => const Color(0xFF3b7d02);
  // static Color get google => const Color(0xFF4885ed);
  // static Color get facebook => const Color(0xFF3b5998);
  // static Color get blackColor =>AppColor.separatorColor;
  // static Color get lightBlueColor => const Color(0xff0077d7).withOpacity(0.6);
  // static Color get greyColor => const Color(0xff8f8f8f);
  // static Color get gradientColorStart => const Color(0xff00b6f3);
  // static final Gradient fabGradient = LinearGradient(
  //     colors: [gradientColorStart, gradientColorEnd],
  //     begin: Alignment.topLeft,
  //     end: Alignment.bottomRight);
  // static Color get gradientColorEnd => const Color(0xff0184dc);

  
  
  //only colors below is being used in app
  
  static Color get iconColors => Colors.white;
  static Color get blackColor => const Color(0xff19191b); //=>main background color of app
  static Color get onlineDotColor => const Color(0xff46dc64);
  static Color get userCircleBackground => const Color(0xff2b2b33);
  static Color get separatorColor => const Color(0xff272c35); // secondary color of app
  static Color get senderColor => const Color(0xff2b343b);
  static Color get receiverColor => const Color(0xff1e2225);

}
