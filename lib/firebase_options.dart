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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCnprbZ_59q1_9XK2uU3D66q9p7s5jGc5c',
    appId: '1:171171724328:web:caba131b547ff364c2c91d',
    messagingSenderId: '171171724328',
    projectId: 'ridelink-carpooling-mobile',
    authDomain: 'ridelink-carpooling-mobile.firebaseapp.com',
    storageBucket: 'ridelink-carpooling-mobile.firebasestorage.app',
    measurementId: 'G-EG2SHTLQLG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwRtm90cOXOh4-5ch_Sr7YCa8PQ7rinEI',
    appId: '1:171171724328:android:4a1fcf276de7c698c2c91d',
    messagingSenderId: '171171724328',
    projectId: 'ridelink-carpooling-mobile',
    storageBucket: 'ridelink-carpooling-mobile.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5mlDthoXTB2hM36st_1oLKAD-5Xo38jo',
    appId: '1:171171724328:ios:668e460825a5e8cec2c91d',
    messagingSenderId: '171171724328',
    projectId: 'ridelink-carpooling-mobile',
    storageBucket: 'ridelink-carpooling-mobile.firebasestorage.app',
    iosBundleId: 'com.mycompany.ridelinkcarpooling',
  );
}
