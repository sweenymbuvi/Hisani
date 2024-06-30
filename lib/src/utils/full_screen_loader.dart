


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisani/src/features/authentication/controllers/helper_controller.dart';

import 'package:hisani/src/constants/colors.dart';
import 'package:hisani/src/utils/helper/animation_loader.dart';

class TFullScreenLoader{


  static void openLoadingDialog(String text, String animation)
  {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
         builder: (_) => PopScope(
          canPop: false,
          child: Container(
            color: Helper.isDarkMode(Get.context!) ? TColors.dark : TColors.white,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [

              const SizedBox( height: 250),
              TAnimationLoaderWidget(text: text, animation: animation),
              ],
            ),
          ),
         ),
    );
  }

  static stopLoading(){
    Navigator.of(Get.overlayContext!).pop();
  }
}