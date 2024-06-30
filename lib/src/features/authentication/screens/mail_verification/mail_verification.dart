import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisani/src/constants/sizes.dart';
import 'package:hisani/src/constants/text_strings.dart';
import 'package:hisani/src/features/authentication/controllers/mail_verification_controller.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MailVerification extends StatelessWidget {
  const MailVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MailVerificationController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LineAwesomeIcons.envelope_open, size: 100),
              const SizedBox(height: tDefaultSize * 2),
              Text(tEmailVerificationTitle.tr,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: tDefaultSize),
              Text(
                tEmailVerificationSubTitle.tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: tDefaultSize * 2),
              SizedBox(
                width: 200,
                child: OutlinedButton(
                  child: Text(tContinue.tr),
                  onPressed: () {
                    // Manually check email verification status
                    controller.manuallyCheckEmailVerificationStatus();
                  },
                ),
              ),
              const SizedBox(height: tDefaultSize * 2),
              TextButton(
                onPressed: () {
                  // Resend verification email
                  controller.sendVerificationEmail();
                },
                child: Text(tResendEmailLink.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
