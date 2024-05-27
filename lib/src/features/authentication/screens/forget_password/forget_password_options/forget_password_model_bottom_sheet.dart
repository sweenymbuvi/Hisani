import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisani/src/constants/sizes.dart';
import 'package:hisani/src/constants/text_strings.dart';
import 'package:hisani/src/features/authentication/controllers/forgot_password_controller.dart';
import 'package:hisani/src/features/authentication/screens/forget_password/forget_password_mail/forget_password_mail.dart';

import 'package:hisani/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';
import 'package:hisani/src/features/authentication/screens/forget_password/reset_password.dart';

import '../forget_password_options/forget_password_btn_widget.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context, String email) {
    // final controller = Get.put(ForgotPasswordController());

    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tForgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium),
              Text(tForgetPasswordSubTitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 30.0),
              ForgetPasswordBtnWidget(
                onTap: () {
                  // Redirect to  verification screen
                  Navigator.pop(context);
                  Get.off(() =>const ForgetPasswordMailScreen());
                },
                title: tEmail,
                subTitle: tResetViaEMail,
                btnIcon: Icons.mail_rounded,
              ),
              const SizedBox(height: 20.0),
              // ForgetPasswordBtnWidget(
              //   onTap: () {
              //     // Redirect to Phone Number verification screen
              //     Navigator.pop(context);
              //     Get.to(() => const OTPScreen());
              //   },
              //   title: tPhoneNo,
              //   subTitle: tResetViaPhone,
              //   btnIcon: Icons.mobile_friendly_rounded,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
