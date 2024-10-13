// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBbbJGSykB0xC7a9p76LBsxpaYdtHUYooU',
    appId: '1:753708941205:web:1ed16b2a47111b469cc09c',
    messagingSenderId: '753708941205',
    projectId: 'hours-19c08',
    authDomain: 'hours-19c08.firebaseapp.com',
    storageBucket: 'hours-19c08.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtoXIN3L0Pko2lKFH88D3gq7gNBiiDdR4',
    appId: '1:753708941205:android:2ab636c3c9d98d229cc09c',
    messagingSenderId: '753708941205',
    projectId: 'hours-19c08',
    storageBucket: 'hours-19c08.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2fmdjCV_RKAn8gIszeOFgoxnSK-w6mvM',
    appId: '1:753708941205:ios:f5167c1441bba8679cc09c',
    messagingSenderId: '753708941205',
    projectId: 'hours-19c08',
    storageBucket: 'hours-19c08.appspot.com',
    iosBundleId: 'com.hours.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2fmdjCV_RKAn8gIszeOFgoxnSK-w6mvM',
    appId: '1:753708941205:ios:08c4eb2def19530e9cc09c',
    messagingSenderId: '753708941205',
    projectId: 'hours-19c08',
    storageBucket: 'hours-19c08.appspot.com',
    iosBundleId: 'com.hours.app.RunnerTests',
  );
}