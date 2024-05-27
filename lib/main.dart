import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hisani/firebase_options.dart';
import 'package:hisani/src/features/authentication/screens/dashboard/dashboard.dart';
import 'package:hisani/src/features/authentication/screens/welcome/welcome.dart';
import 'package:hisani/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hisani/src/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthenticationRepository());
  await GetStorage.init();
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
