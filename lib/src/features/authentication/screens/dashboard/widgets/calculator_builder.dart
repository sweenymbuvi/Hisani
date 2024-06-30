import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hisani/src/constants/colors.dart'; // Adjust with your actual colors import
import 'package:hisani/src/features/authentication/screens/payment/payment_screen.dart';
import 'calculator.dart'; // Import the Calculator widget

class CalculatorBuilder extends StatelessWidget {
  const CalculatorBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 16.h,
                bottom: 8.h,
              ),
              child: SvgPicture.asset(
                'assets/images/close.svg',
                color: AppColor.kPrimaryColor.withOpacity(0.5),
                width: 32.w,
              ),
            ),
            Calculator(
              (value) {
                // Handle value callback if needed
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          AppColor.kPrimaryColor,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8.r,
                            ),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all(
                          Size(0, 56.h),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to PaymentScreen when the Donate button is pressed
                        Get.toNamed('/payment');
                      },
                      child: Text('Donate'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
