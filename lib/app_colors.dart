import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF000000);
  static const primaryHover = Color(0xFF312F2F);
  static const secondary = Color(0xFFFF6962);
  static const secondary2 = Color(0xFF5E6BD8);
  static const primarySwatch = appPrimarySwatch;
}

const MaterialColor appPrimarySwatch = MaterialColor(
  _appPrimarySwatchValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_appPrimarySwatchValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _appPrimarySwatchValue = 0xFF000000;
