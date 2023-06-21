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
    apiKey: 'AIzaSyBrcerijVqtuxpXp1MZZD72gSMdR-_4y8w',
    appId: '1:129102410527:web:860a1ac1bc99e12caab62a',
    messagingSenderId: '129102410527',
    projectId: 'topics-project-42f57',
    authDomain: 'topics-project-42f57.firebaseapp.com',
    storageBucket: 'topics-project-42f57.appspot.com',
    measurementId: 'G-5QC6LM6R0W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfbRadmfrorD_LyJf1syI_pjHb41wRWHg',
    appId: '1:129102410527:android:bdf1d7d70f544a66aab62a',
    messagingSenderId: '129102410527',
    projectId: 'topics-project-42f57',
    storageBucket: 'topics-project-42f57.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCCn9B9gHym4yP8SlicpEPIn17msYtOn3Y',
    appId: '1:129102410527:ios:760c362a905ce85eaab62a',
    messagingSenderId: '129102410527',
    projectId: 'topics-project-42f57',
    storageBucket: 'topics-project-42f57.appspot.com',
    androidClientId: '129102410527-hh4bcia5m1fjonu7uj723lcjbnbgu8ir.apps.googleusercontent.com',
    iosClientId: '129102410527-6d0d4ij5fm0pncq6oubtb1eubs3tkd73.apps.googleusercontent.com',
    iosBundleId: 'com.example.projectTopicsMovil',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCCn9B9gHym4yP8SlicpEPIn17msYtOn3Y',
    appId: '1:129102410527:ios:760c362a905ce85eaab62a',
    messagingSenderId: '129102410527',
    projectId: 'topics-project-42f57',
    storageBucket: 'topics-project-42f57.appspot.com',
    androidClientId: '129102410527-hh4bcia5m1fjonu7uj723lcjbnbgu8ir.apps.googleusercontent.com',
    iosClientId: '129102410527-6d0d4ij5fm0pncq6oubtb1eubs3tkd73.apps.googleusercontent.com',
    iosBundleId: 'com.example.projectTopicsMovil',
  );
}