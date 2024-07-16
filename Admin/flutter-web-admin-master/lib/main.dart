import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/auth.dart';
import 'package:web_admin/environment.dart';
import 'package:web_admin/root_app.dart';
import 'package:web_admin/theme/themes.dart';
import 'package:web_admin/views/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Environment.init(
    apiBaseUrl: 'https://example.com',
  );

  await Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid
          ? FirebaseOptions(
              apiKey: "AIzaSyBh5hAwvTCakKOcs8SuLBEBKlelEGnzUlM",
              appId: "1:220787537015:web:c3a9a3758a2b667ddf4272",
              messagingSenderId: "G-0HMKW2HSJJ",
              projectId: "hisani-edc9d",
              authDomain: "hisani-edc9d.firebaseapp.com",
              storageBucket: "hisani-edc9d.appspot.com",
            )
          : null);
// await Firebase.initializeApp(

//   options:  FirebaseOptions(apiKey:"AIzaSyBh5hAwvTCakKOcs8SuLBEBKlelEGnzUlM",
//   authDomain: "hisani-edc9d.firebaseapp.com",
//   appId:"1:220787537015:web:c3a9a3758a2b667ddf4272",
//   messagingSenderId: "G-0HMKW2HSJJ",
//   projectId: "hisani-edc9d",
//   storageBucket:  "hisani-edc9d.appspot.com"
//    ),
// );

  runApp(const RootApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> getUserInfo() async {
    await getUser();
    setState(() {});
    print("User ID: $uid");
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hisani',
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteUri.home,
    );
  }
}
