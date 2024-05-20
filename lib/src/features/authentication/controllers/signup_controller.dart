import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisani/src/constants/text_strings.dart';
import 'package:hisani/src/features/authentication/models/user_model.dart';
import 'package:hisani/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hisani/src/repository/user_repository/user_repository.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();

  final userRepo = Get.put(UserRepository());

  Future<void> registerUser(String email, String password) async {
    try {
      // Create user account
      await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(email, password);

      // Send verification email
      await AuthenticationRepository.instance.sendEmailVerification();

      // Show success message
      Get.snackbar(
        'Success',
        'Sign up successful! Verification email sent.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear the form fields
      clearFormFields();
    } catch (error) {
      // Show error message
      Get.snackbar(
        'Error',
        error.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clearFormFields() {
    email.clear();
    password.clear();
    fullName.clear();
    phoneNo.clear();
  }

  Future<void> createUser(UserModel user) async {
    userRepo.createUser(user);
  }
}
