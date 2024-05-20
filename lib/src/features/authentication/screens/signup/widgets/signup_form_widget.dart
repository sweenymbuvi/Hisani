import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisani/src/constants/sizes.dart';
import 'package:hisani/src/constants/text_strings.dart';
import 'package:hisani/src/features/authentication/controllers/signup_controller.dart';
import 'package:hisani/src/features/authentication/models/user_model.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final _formKey = GlobalKey<FormState>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.fullName,
              decoration: const InputDecoration(
                labelText: tFullName,
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                labelText: tEmail,
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: controller.phoneNo,
              decoration: const InputDecoration(
                labelText: tPhoneNo,
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: controller.password,
              decoration: const InputDecoration(
                labelText: tPassword,
                prefixIcon: Icon(Icons.fingerprint),
              ),
            ),
            const SizedBox(height: tFormHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final user = UserModel(
                      email: controller.email.text.trim(),
                      password: controller.password.text.trim(),
                      fullName: controller.fullName.text.trim(),
                      phoneNo: controller.phoneNo.text.trim(),
                    );
                    SignupController.instance.createUser(user);
                  }
                },
                child: Text(tSignup.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
