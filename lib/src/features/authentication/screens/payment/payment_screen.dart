import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisani/src/constants/colors.dart';
import 'package:hisani/src/features/authentication/screens/payment/payment_bloc.dart';
import 'package:equatable/equatable.dart';

// Define your payment methods
final List<PaymentMethod> methods = [
  PaymentMethod(
    name: 'Credit Card',
    assetName: 'assets/images/visa.png',
  ),
  PaymentMethod(
    name: 'M-Pesa',
    assetName: 'assets/images/mpesa.png',
  ),
  PaymentMethod(
    name: 'PayPal',
    assetName: 'assets/images/paypal.webp',
  )
];

class PaymentMethod extends Equatable {
  final String name;
  final String assetName;

  PaymentMethod({
    required this.name,
    required this.assetName,
  });

  @override
  List<Object?> get props => [name, assetName];
}

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Payment Method'), // Updated title
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 16.w, vertical: 12.h), // Reduced padding
        child: ListView.builder(
          itemCount: methods.length,
          itemBuilder: (context, index) {
            final method = methods[index];
            return GestureDetector(
              onTap: () {
                BlocProvider.of<PaymentBloc>(context).add(ChangePayment(index));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColor.kPlaceholder2,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColor.kPrimaryColor,
                    width: 2.sp,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.kPrimaryColor,
                            width: 2.sp,
                          ),
                        ),
                        child: Center(
                          child: BlocBuilder<PaymentBloc, PaymentState>(
                            builder: (context, state) {
                              return state.index == index
                                  ? Container(
                                      width: 16.w,
                                      height: 16.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.kPrimaryColor,
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        method.name,
                        style: TextStyle(
                          color: AppColor.kTextColor1,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    SizedBox(
                      height: 24.h,
                      child: Image.asset(method.assetName),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: ElevatedButton(
          onPressed: () {
            // Implement payment processing logic here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Payment Processing'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
            child: Text(
              'Donate',
              style: TextStyle(fontSize: 18.sp),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }
}
