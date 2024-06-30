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

class AppColor {
  static const kPrimaryColor = Color(0xFF0E4944);
  static const kAccentColor = Color(0xFF9BD35A);
  static const kThirdColor = Color(0xFFDBF4E9);
  static const kForthColor = Color(0xFFB3CDC5);
  static const kBlue = Color(0xFFC5E5F8);

  static const kPlaceholder1 = Color(0xFFD8D8D8);
  static const kPlaceholder2 = Color(0xFFF5F6F8);
  static const kPlaceholder3 = Color(0xFFF4F4F6);

  static const kTextColor1 = Color(0xFFC9C9C9);
  static const kTextColor2 = Color(0xFFDEDEDE);
  static const kTitle = Color(0xFF3B3B3B);
}
