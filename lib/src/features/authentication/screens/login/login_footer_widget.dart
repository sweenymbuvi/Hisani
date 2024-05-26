import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisani/src/constants/image_strings.dart';
import 'package:hisani/src/constants/sizes.dart';
import 'package:hisani/src/constants/text_strings.dart';
import 'package:hisani/src/features/authentication/controllers/login_controller.dart';
import 'package:hisani/src/features/authentication/screens/dashboard/dashboard.dart';
import 'package:hisani/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:hisani/src/services/local_auth.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(height: tFormHeight - 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: Image(image: AssetImage(tGoogleImage), width: 40.0),
            onPressed: () {
              controller.googleSignIn();
            },
            label: Text(tSignInWithGoogle),
          ),
        ),
        const SizedBox(height: tFormHeight - 20),
        TextButton(
          onPressed: () {
            Get.to(() => const SignUpScreen());
          },
          child: Text.rich(
            TextSpan(
              text: tDontHaveAnAccount,
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: tSignup,
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
        Obx(() {
          if (controller.isLoading.value) {
            return CircularProgressIndicator();
          } else {
            return Container();
          }
        }),
        // Add a fingerprint authentication button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: Icon(Icons.fingerprint, size: 40.0),
            onPressed: () async {
              bool authenticated = await LocalAuth.authenticate();
              if (authenticated) {
                // Redirect to the dashboard screen
                Get.offAll(() => Dashboard());
              } else {
                // Handle failed authentication
                Get.snackbar(
                  'Authentication Failed',
                  'Could not authenticate using fingerprint',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            label: Text('Use Fingerprint'),
          ),
        ),
      ],
    );
  }
}
