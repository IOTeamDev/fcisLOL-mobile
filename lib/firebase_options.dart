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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyByioDFW9zYJ_xkFyYB0wha_dOu742w1LU',
    appId: '1:173089782568:web:9ee641a2d817e7fea36e1d',
    messagingSenderId: '173089782568',
    projectId: 'fcis-da7f4',
    authDomain: 'fcis-da7f4.firebaseapp.com',
    storageBucket: 'fcis-da7f4.appspot.com',
    measurementId: 'G-NWFWTC2CK4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDedD9YOtikZZ5-fJhO0WIK-miXSpnofns',
    appId: '1:173089782568:android:d0615cb13ebf44e6a36e1d',
    messagingSenderId: '173089782568',
    projectId: 'fcis-da7f4',
    storageBucket: 'fcis-da7f4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2Fdu_yP2CqQ_fnZhssQ1PUm9voA4Mb4Q',
    appId: '1:173089782568:ios:f13c8608f9e93d9aa36e1d',
    messagingSenderId: '173089782568',
    projectId: 'fcis-da7f4',
    storageBucket: 'fcis-da7f4.appspot.com',
    androidClientId: '173089782568-iq7j2lh65gp9jtr8ff04nq5emrq7emm8.apps.googleusercontent.com',
    iosBundleId: 'com.example.mobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB2Fdu_yP2CqQ_fnZhssQ1PUm9voA4Mb4Q',
    appId: '1:173089782568:ios:f13c8608f9e93d9aa36e1d',
    messagingSenderId: '173089782568',
    projectId: 'fcis-da7f4',
    storageBucket: 'fcis-da7f4.appspot.com',
    androidClientId: '173089782568-iq7j2lh65gp9jtr8ff04nq5emrq7emm8.apps.googleusercontent.com',
    iosBundleId: 'com.example.mobile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAiowrFaf-ccL6PVcfsx-_cvmoe11bPdrM',
    appId: '1:173089782568:web:383de38cb67e09a1a36e1d',
    messagingSenderId: '173089782568',
    projectId: 'fcis-da7f4',
    authDomain: 'fcis-da7f4.firebaseapp.com',
    storageBucket: 'fcis-da7f4.appspot.com',
    measurementId: 'G-PNPL3R6VX2',
  );
}
