// ResetPasswordScreen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisani/src/constants/image_strings.dart';
import 'package:hisani/src/constants/text_strings.dart';
import 'package:hisani/src/constants/sizes.dart';
import 'package:hisani/src/features/authentication/controllers/forgot_password_controller.dart';
import'package:hisani/src/features/authentication/screens/forget_password/validation.dart';


import 'package:hisani/src/features/authentication/screens/login/login_screen.dart';
import 'package:hisani/src/utils/helper/helper.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;
  

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () =>Get.back,icon: const Icon (CupertinoIcons.clear))],
          
          ),
      
    
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              // Image
              Image(
                image: const AssetImage(TImages.deliverEmailIllustration),
                width: Helper.screenWidth() * 0.6,
              ),
              const SizedBox(height: tDefaultSize),

              // Email, Title, and Subtitle
              Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                TTexts.changeYourPasswordTitle, // Assuming this should be the title
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: tDefaultSize),
              Text(
                TTexts.changeYourPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                 onPressed: () {
  Get.offAll(() =>const  LoginScreen());
  if (Get.isSnackbarOpen) Get.back(); // Dismiss any existing snackbars
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Password was reset successfully'),
    ),
  );


                    // Navigate to login screen
                   
                  },
                  child: const Text(TTexts.done),
                ),
              ),
              const SizedBox(height: tDefaultSize),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => ForgotPasswordController.instance.resendPasswordResetEmail(email),
                  child: const Text(TTexts.resendEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
