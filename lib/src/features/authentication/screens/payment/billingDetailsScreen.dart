import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:hisani/src/features/authentication/screens/billing/mpesa_screen.dart';
import 'package:hisani/src/features/authentication/screens/payment/mpesa_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:hisani/src/constants/colors.dart';

class BillingDetailsScreen extends StatelessWidget {
  const BillingDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          'Billing Details',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BillingOption(
              imagePath: 'assets/images/billing/mpesa.png',
              title: 'Mpesa',
              onTap: () {
                Get.to(() => const MpesaScreen());
              },
            ),
            const SizedBox(height: 16.0),
            BillingOption(
              imagePath: 'assets/images/billing/visa.png',
              title: 'Visa Card',
              onTap: () {
                // Handle Visa Card click
              },
            ),
            const SizedBox(height: 16.0),
            BillingOption(
              imagePath: 'assets/images/billing/paypal.jpg',
              title: 'PayPal',
              onTap: () {
                // Handle PayPal click
              },
            ),
            const SizedBox(height: 16.0),
            BillingOption(
              imagePath: 'assets/images/billing/cash.jpg',
              title: 'Cash',
              onTap: () {
                // Handle Cash click
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BillingOption extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const BillingOption({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: tWhiteColor,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        alignment: Alignment.centerLeft, // Align text to the left
      ),
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          imagePath,
          width: 45.0,
          height: 45.0,
        ),
      ),
      label: Padding(
        padding: const EdgeInsets.only(left: 16.0), // Adjust left padding as needed
        child: Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 16.0),
        ),
      ),
    );
  }
}
