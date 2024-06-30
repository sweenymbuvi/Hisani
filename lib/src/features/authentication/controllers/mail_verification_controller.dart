import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hisani/src/constants/text_strings.dart';
import 'package:hisani/src/features/authentication/screens/login/login_screen.dart';
import 'package:hisani/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hisani/src/utils/helper/helper.dart';

class MailVerificationController extends GetxController {
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    sendVerificationEmail();
    // setTimeForAutoRedirect();
  }

  Future<void> sendVerificationEmail() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
    } catch (e) {
      // Helper.errorSnackBar(title: tOhSnap, message: e.toString());
    }
  }

  // void setTimeForAutoRedirect() {
  //   _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
  //     await FirebaseAuth.instance.currentUser?.reload();
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user != null && user.emailVerified) {
  //       timer.cancel();
  //       // Redirect to the dashboard
  //       Get.offAll(() => const LoginScreen());
  //     }
  //   });
  // }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  void manuallyCheckEmailVerificationStatus() async {
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      _timer.cancel();
      Get.off(() => const LoginScreen());
    } else {
      Helper.errorSnackBar(title: tOhSnap, message: "Email not verified yet.");
    }
    @override
    void onClose() {
      _timer.cancel();
      super.onClose();
    }
  }
}
