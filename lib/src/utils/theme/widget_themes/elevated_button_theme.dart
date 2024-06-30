import 'package:flutter/material.dart';
import 'package:hisani/src/constants/colors.dart';
import 'package:hisani/src/constants/sizes.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(),
      foregroundColor: tWhiteColor,
      backgroundColor: tSecondaryColor,
      padding: EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(),
      foregroundColor: tSecondaryColor,
      backgroundColor: tWhiteColor,
      padding: EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );
}
