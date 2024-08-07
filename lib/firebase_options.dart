// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBh5hAwvTCakKOcs8SuLBEBKlelEGnzUlM',
    appId: '1:220787537015:web:c3a9a3758a2b667ddf4272',
    messagingSenderId: '220787537015',
    projectId: 'hisani-edc9d',
    authDomain: 'hisani-edc9d.firebaseapp.com',
    storageBucket: 'hisani-edc9d.appspot.com',
    measurementId: 'G-0HMKW2HSJJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAl_V8lSTAm62SZF4tl_ujevadumEm7PzM',
    appId: '1:220787537015:android:9589daf7220dcc2cdf4272',
    messagingSenderId: '220787537015',
    projectId: 'hisani-edc9d',
    storageBucket: 'hisani-edc9d.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBh5hAwvTCakKOcs8SuLBEBKlelEGnzUlM',
    appId: '1:220787537015:web:514ba27a935a5ebddf4272',
    messagingSenderId: '220787537015',
    projectId: 'hisani-edc9d',
    authDomain: 'hisani-edc9d.firebaseapp.com',
    storageBucket: 'hisani-edc9d.appspot.com',
    measurementId: 'G-F3LQ2V9JT6',
  );
}
