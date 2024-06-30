


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hisani/src/constants/colors.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';


class Helper {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static void errorSnackBar({required String title, required String message}) {
    // Show error snackbar
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}