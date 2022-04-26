// ignore_for_file: file_names

import 'package:intl/intl.dart';

import 'handlers.dart';

class Formatter {
  static String format(dynamic num) {
    if (num.isNotEmpty && isNumeric(num)) {
      var money = NumberFormat("#,##0.00", "en_US");
      return money.format(double.parse(num));
    } else {
      return "0";
    }
  }
}
