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
    apiKey: 'AIzaSyCZO5hRabFIM_JKeud34JhOzBhlhRRxx-o',
    appId: '1:1092602569915:web:6774187282468298e1359e',
    messagingSenderId: '1092602569915',
    projectId: 'and20roid-a7e09',
    authDomain: 'and20roid-a7e09.firebaseapp.com',
    storageBucket: 'and20roid-a7e09.appspot.com',
    measurementId: 'G-W87VPE4HLM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvZaKCj4zILZogQ0yy2_DBPMv4QCgTzwo',
    appId: '1:1092602569915:android:64440326b23c3919e1359e',
    messagingSenderId: '1092602569915',
    projectId: 'and20roid-a7e09',
    storageBucket: 'and20roid-a7e09.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXX8sFu37-z7vD4CTJfCXDpqn6b9pyErg',
    appId: '1:1092602569915:ios:e772a2422c1e730ce1359e',
    messagingSenderId: '1092602569915',
    projectId: 'and20roid-a7e09',
    storageBucket: 'and20roid-a7e09.appspot.com',
    iosBundleId: 'com.codekunst.and20roid',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAXX8sFu37-z7vD4CTJfCXDpqn6b9pyErg',
    appId: '1:1092602569915:ios:4987a2b0124e6955e1359e',
    messagingSenderId: '1092602569915',
    projectId: 'and20roid-a7e09',
    storageBucket: 'and20roid-a7e09.appspot.com',
    iosBundleId: 'com.codekunst.and20roid.RunnerTests',
  );
}
