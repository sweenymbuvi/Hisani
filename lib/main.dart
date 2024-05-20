import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisani/firebase_options.dart';
import 'package:hisani/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';
import 'package:hisani/src/features/authentication/screens/login/login_screen.dart';
import 'package:hisani/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:hisani/src/features/authentication/screens/welcome/welcome.dart';
import 'package:hisani/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hisani/src/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthenticationRepository());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const WelcomeScreen(),
      // Define routes for other screens if needed
      // routes: {
      //   '/login': (_) => const LoginScreen(),
      //   '/signup': (_) => const SignUpScreen(),
      //   '/otp': (_) => const OTPScreen(),
      // },
    );
  }
}
