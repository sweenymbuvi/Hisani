import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisani/src/constants/sizes.dart';
import 'package:hisani/src/constants/text_strings.dart';
import 'package:hisani/src/features/authentication/controllers/login_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: tEmail,
                hintText: tEmail,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            Obx(() => TextFormField(
                  controller: controller.password,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    labelText: tPassword,
                    hintText: tPassword,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.showPassword.value =
                            !controller.showPassword.value;
                      },
                      icon: Icon(controller.showPassword.value
                          ? Icons.remove_red_eye_sharp
                          : Icons.remove_red_eye_outlined),
                    ),
                  ),
                  obscureText: !controller.showPassword.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                )),
            const SizedBox(height: tFormHeight - 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () {}, child: Text(tForgetPassword)),
            ),
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            controller.login();
                          },
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(tLogin.toUpperCase()),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
