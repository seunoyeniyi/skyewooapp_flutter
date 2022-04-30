import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skyewooapp/app_colors.dart';

class ToastBar {
  static void show(BuildContext context, String message,
      {String title = "Alert",
      FlushbarPosition position = FlushbarPosition.TOP,
      int duration = 3}) {
    Flushbar(
      flushbarPosition: position,
      title: title,
      message: message,
      duration: Duration(seconds: duration),
    ).show(context);
  }
}

class Toaster {
  static void show({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Toast length = Toast.LENGTH_LONG,
    Color background = AppColors.primary,
    Color textColor = AppColors.onPrimary,
    double fontSize = 16.0,
  }) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: length,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: background,
        textColor: textColor,
        fontSize: fontSize);
  }
}

class AppRoute {
  static String getName(BuildContext context) {
    return ModalRoute.of(context)!.settings.name ?? "";
  }
}

bool isNumeric(String str) {
  return double.tryParse(str) != null;
}
