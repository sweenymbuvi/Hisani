import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hisani/src/common_widgets/form/form_header_widget.dart";
import "package:hisani/src/constants/image_strings.dart";
import "package:hisani/src/constants/sizes.dart";
import "package:hisani/src/constants/text_strings.dart";
import "package:hisani/src/features/authentication/controllers/forgot_password_controller.dart";
import "package:hisani/src/features/authentication/screens/forget_password/validation.dart";
// import '../../../../../common_widgets/form/form_header_widget.dart';


class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    return SafeArea(
      child: Scaffold( 
        body:  SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                const SizedBox(height: tDefaultSize * 4),
          

              
      const FormHeaderWidget(
            image: tForgetPasswordImage,
             title: tForgetPassword, 
             subTitle:tForgotPasswordMailTitle,
        
          ),
          Form(
            key: controller.forgotPasswordFormKey,
                child: TextFormField(
                  controller: controller.email,
           validator: TValidator.validateEmail,
          
                  decoration: const InputDecoration( 
                    label: Text(tEmail),
                    hintText: tEmail,
                    prefixIcon: Icon(Icons.mail_outline_rounded),
                  
                  ),
                ),
          ),
                const SizedBox(height: TSizes.spaceBtwItems),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton
                  (onPressed: (){
                  controller.sendPasswordResetEmail();
                  
                  },
                 child: const Text(tNext),
                  ),
                ),
              ],
            ),
            ),
        ),
      ),
    );
           
  }
}