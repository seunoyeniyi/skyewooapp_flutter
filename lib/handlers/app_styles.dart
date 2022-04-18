import 'package:flutter/material.dart';

class AppStyles {
  static ButtonStyle flatButtonStyle(
      {Key? key,
      EdgeInsetsGeometry padding = const EdgeInsets.all(0),
      Color backgroundColor = Colors.green,
      Size minimumSize = const Size.fromHeight(30),
      Color primary = Colors.white}) {
    return TextButton.styleFrom(
      primary: primary,
      minimumSize: minimumSize,
      backgroundColor: backgroundColor,
      padding: padding,
    );
  }
}
