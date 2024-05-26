import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisani/src/features/authentication/models/user_model.dart';
import 'package:hisani/src/features/authentication/screens/mail_verification/mail_verification.dart';
import 'package:hisani/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hisani/src/repository/user_repository/user_repository.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();

  final userRepo = Get.put(UserRepository());

  // Define isLoading property
  var _isLoading = false.obs;

  // Getter for isLoading
  bool get isLoading => _isLoading.value;

  Future<void> registerUser(String email, String password) async {
    try {
      // Set isLoading to true when registering user
      _isLoading(true);

      // Create user account in Firebase Authentication
      await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(email, password);

      // Send verification email
      await AuthenticationRepository.instance.sendEmailVerification();

      // Create user document in Firestore
      UserModel newUser = UserModel(
        email: email,
        fullName: fullName.text.trim(),
        phoneNo: phoneNo.text.trim(),
        password: password,
      );
      userRepo.createUser(newUser);

      // Show success message
      Get.snackbar(
        'Success',
        'Sign up successful! Verification email sent.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear the form fields
      clearFormFields();

      // Redirect to the email verification screen
      Get.off(() => const MailVerification());
    } catch (error) {
      // Show error message
      Get.snackbar(
        'Error',
        error.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Set isLoading to false after operation completes
      _isLoading(false);
    }
  }

  void clearFormFields() {
    email.clear();
    password.clear();
    fullName.clear();
    phoneNo.clear();
  }
}
