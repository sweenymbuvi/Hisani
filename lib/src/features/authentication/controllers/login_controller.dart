import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hisani/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hisani/src/constants/text_strings.dart';

class LoginController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var showPassword = false.obs;

  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      isLoading.value = true;

      String? loginError = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      isLoading.value = false;

      if (loginError == null) {
        // Show success message
        Get.snackbar(
          'Success',
          'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Show error message
        Get.snackbar(
          'Login Failed',
          loginError,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
