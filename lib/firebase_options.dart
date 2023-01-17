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
///

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
    apiKey: 'AIzaSyC_9FtMNPei7HchTwg7maI1i3eB5b3rbmA',
    appId: '1:818411204421:web:dbd56a7ed062aef277982c',
    messagingSenderId: '818411204421',
    projectId: 'ppocus-e6a62',
    authDomain: 'ppocus-e6a62.firebaseapp.com',
    storageBucket: 'ppocus-e6a62.appspot.com',
    measurementId: 'G-M9JJY40YYH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_-rd2Jgt1oXuSWBBVCpaRy0azwI0VHjU',
    appId: '1:818411204421:android:248193e5f788451377982c',
    messagingSenderId: '818411204421',
    projectId: 'ppocus-e6a62',
    storageBucket: 'ppocus-e6a62.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDotFRdI3GP0nkjM9DMVKAdYo-Xq18LGos',
    appId: '1:818411204421:ios:68f934cc402acebb77982c',
    messagingSenderId: '818411204421',
    projectId: 'ppocus-e6a62',
    storageBucket: 'ppocus-e6a62.appspot.com',
    iosClientId:
        '818411204421-ppcfp06r5ujvsrfbiu4hj2574phvfegt.apps.googleusercontent.com',
    iosBundleId: 'com.example.ppocus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDotFRdI3GP0nkjM9DMVKAdYo-Xq18LGos',
    appId: '1:818411204421:ios:68f934cc402acebb77982c',
    messagingSenderId: '818411204421',
    projectId: 'ppocus-e6a62',
    storageBucket: 'ppocus-e6a62.appspot.com',
    iosClientId:
        '818411204421-ppcfp06r5ujvsrfbiu4hj2574phvfegt.apps.googleusercontent.com',
    iosBundleId: 'com.example.ppocus',
  );
}