import 'package:flutter/material.dart';

const tPrimaryColor = Color(0xFFFFE400);
const tSecondaryColor = Color(0xFF272727);
const tAccentColor = Color(0xFF001BFF);

const tWhiteColor = Colors.white;
const tDarkColor = Color(0xff00000);
const tCardBgColor = Color(0xFFF76F1);

const tOnBoardingPage1Color = Colors.white;
const tOnBoardingPage2Color = Color(0xfffddcdf);
const tOnBoardingPage3Color = Color(0xffffbcbd);

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

class TColors {
  static const Color primary = Color(0xFFFFE400);
  static const Color secondary = Color(0xFF272727);
  static const Color accent = Color(0xFF001BFF);

  static const Color white = Colors.white;
  static const Color dark = Color(0xff000000);
  static const Color cardBg = Color(0xFFF76F1);

  static const Color grey = Colors.grey;
  static const Color darkerGrey = Color(0xFF555555);

  static const Color onBoardingPage1 = Colors.white;
  static const Color onBoardingPage2 = Color(0xfffddcdf);
  static const Color onBoardingPage3 = Color(0xffffbcbd);
}