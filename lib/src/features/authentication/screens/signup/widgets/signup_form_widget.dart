import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisani/src/constants/sizes.dart';
import 'package:hisani/src/constants/text_strings.dart';
import 'package:hisani/src/features/authentication/screens/mail_verification/mail_verification.dart';
import 'package:hisani/src/features/authentication/controllers/signup_controller.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({Key? key}) : super(key: key);

  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _showPassword = false;

  // Get instance of the signup controller
  final SignupController _signupController = Get.put(SignupController());

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!_containsSpecialCharacters(value)) {
      return 'Password must contain special characters';
    }
    return null;
  }

  bool _containsSpecialCharacters(String value) {
    final specialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return specialCharacters.hasMatch(value);
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    } else if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _signUp() {
    if (_formKey.currentState?.validate() ?? false) {
      // Call the registerUser method from SignUpController
      _signupController.registerUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: tFullName,
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Full name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: tEmail,
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                } else if (!value.contains('@')) {
                  return 'Invalid email format';
                }
                return null;
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: tPhoneNo,
                prefixText: '+254', // Prefill with +254
                prefixStyle: TextStyle(color: Colors.black), // Set prefix color
                prefixIcon: Icon(Icons.phone), // Add phone icon
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                return null;
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                labelText: tPassword,
                prefixIcon: Icon(Icons.fingerprint),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off),
                ),
              ),
              validator: _validatePassword,
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                labelText: tConfirmPassword,
                prefixIcon: Icon(Icons.fingerprint),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off),
                ),
              ),
              validator: _validateConfirmPassword,
            ),
            const SizedBox(height: tFormHeight - 10),
            SizedBox(
              width: double.infinity,
              child: Obx(() {
                return _signupController.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _signUp,
                        child: Text(tSignup.toUpperCase()),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
