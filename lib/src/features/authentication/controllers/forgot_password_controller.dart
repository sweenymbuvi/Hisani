// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:hisani/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hisani/src/utils/full_screen_loader.dart';
import 'package:hisani/src/utils/loader.dart';
import 'package:hisani/src/constants/image_strings.dart';

import '../screens/forget_password/reset_password.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  // Variables
  final email = TextEditingController();
  final forgotPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail() async {
    try {
       TFullScreenLoader.openLoadingDialog('Processing your request....', TImages.docerAnimation);

      // Check internet connectivity here (optional)
//form validation

if (!forgotPasswordFormKey.currentState!.validate()){
  TFullScreenLoader.stopLoading();
  return;
}
     
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      // Remove the loader
      TFullScreenLoader.stopLoading();

      // Show success confirmation
      TLoaders.successSnackBar(title: 'Email Sent', message: 'Email Link Sent to Reset your Password'.tr);

      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } 
    catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      TFullScreenLoader.openLoadingDialog('Processing your request....', TImages.docerAnimation);

      // Check internet connectivity here (optional)

      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      // Remove the loader
      TFullScreenLoader.stopLoading();

      // Show success confirmation
      TLoaders.successSnackBar(title: 'Email Sent', message: 'Email Link Sent to Reset your Password'.tr);

      
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
  
  String handleFirebaseAuthError(String code) {
    // Implement logic to handle different error codes from FirebaseAuthException
    // and return appropriate messages for the user.
    switch (code) {
      case "user-not-found":
        return "The email address you entered is not associated with an account.";
      case "invalid-email":
        return "The email address is not valid.";
      case "too-many-requests":
        return "Too many requests. Try again later.";
      default:
        return "An error occurred. Please try again.";
    }
  }
}
