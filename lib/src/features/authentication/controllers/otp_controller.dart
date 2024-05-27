
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hisani/src/features/authentication/screens/dashboard/dashboard.dart';
import 'package:hisani/src/features/authentication/screens/login/login_screen.dart';
import 'package:hisani/src/repository/authentication_repository/authentication_repository.dart';

import '../screens/forget_password/reset_password.dart';

class OtpController extends GetxController {
  static OtpController get instance => Get.find();

  void verifyOTP(String otp) async {
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    if (isVerified) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        Get.offAll(() => const Dashboard()); // Redirect to Dashboard
      } else {
        Get.offAll(() => ResetPasswordScreen(email: user?.email ?? ""));
        // Redirect to ResetPasswordScreen if email not verified
      }
    } else {
      Get.back();
    }
  }
}
