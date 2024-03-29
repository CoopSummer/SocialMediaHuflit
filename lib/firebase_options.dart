// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBM3bKdqZtOBnrE4_pFa9lzV0YkdTrNl6c',
    appId: '1:951670337237:web:52387e466f44d624bd7c5c',
    messagingSenderId: '951670337237',
    projectId: 'mobilekihainamcuoi',
    authDomain: 'mobilekihainamcuoi.firebaseapp.com',
    storageBucket: 'mobilekihainamcuoi.appspot.com',
    measurementId: 'G-RLL7J444S3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5NWciCQ6Jud51EI1B3g8asJEQS7e6bQE',
    appId: '1:951670337237:android:844c85e5ae74afb3bd7c5c',
    messagingSenderId: '951670337237',
    projectId: 'mobilekihainamcuoi',
    storageBucket: 'mobilekihainamcuoi.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDsgyrK4YvOcegHxTuL16W770O_S2j1_NM',
    appId: '1:951670337237:ios:e4c0832bec25e3fabd7c5c',
    messagingSenderId: '951670337237',
    projectId: 'mobilekihainamcuoi',
    storageBucket: 'mobilekihainamcuoi.appspot.com',
    androidClientId: '951670337237-cvi35q7qog4pod7urbuce69jar03ocgc.apps.googleusercontent.com',
    iosClientId: '951670337237-iqjlsm3gbeqciguhislr9350mivp8422.apps.googleusercontent.com',
    iosBundleId: 'SocialHuflit',
  );
}
