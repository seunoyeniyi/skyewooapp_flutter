import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';

class Toast {
  static void show(BuildContext context, String message,
      {String title = "Alert",
      FlushbarPosition position = FlushbarPosition.TOP}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
    ).show(context);
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
