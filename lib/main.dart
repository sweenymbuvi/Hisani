import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import for BlocProvider
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hisani/firebase_options.dart';
import 'package:hisani/src/features/authentication/screens/dashboard/dashboard.dart';
import 'package:hisani/src/features/authentication/screens/payment/payment_bloc.dart';
import 'package:hisani/src/features/authentication/screens/payment/payment_screen.dart';
import 'package:hisani/src/features/authentication/screens/welcome/welcome.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisani/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hisani/src/repository/user_repository/user_repository.dart';
import 'package:hisani/src/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthenticationRepository());
  await GetStorage.init();
  Get.put<UserRepository>(UserRepository());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812), // Example design size, adjust as needed
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => PaymentBloc(), 
          child: GetMaterialApp(
            theme: TAppTheme.lightTheme,
            darkTheme: TAppTheme.darkTheme,
            themeMode: ThemeMode.system,
            home: child,
            getPages: [
              GetPage(name: '/', page: () => WelcomeScreen()),
              GetPage(name: '/dashboard', page: () => Dashboard()),
              GetPage(
                  name: '/payment',
                  page: () => PaymentScreen()), // Add the PaymentScreen route
            ],
          ),
        );
      },
      child: const WelcomeScreen(), // Your initial screen
    );
  }
}