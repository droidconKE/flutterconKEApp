// File generated by FlutterFire CLI.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for fuchsia - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBY00roSeNZOq5AaLnHWYkSN-FnxtkUrrc',
    appId: '1:602867001820:android:689e781aad67bd0b710719',
    messagingSenderId: '602867001820',
    projectId: 'droidconke-70d60',
    databaseURL: 'https://droidconke-70d60.firebaseio.com',
    storageBucket: 'droidconke-70d60.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAi97080KkYdRcS-RYhRQbhxqzLhh1iME0',
    appId: '1:602867001820:ios:ae6578a57dca9221710719',
    messagingSenderId: '602867001820',
    projectId: 'droidconke-70d60',
    databaseURL: 'https://droidconke-70d60.firebaseio.com',
    storageBucket: 'droidconke-70d60.appspot.com',
    androidClientId: '602867001820-01m5er098dknofg7rdktcqj33atavm5c'
        '.apps.googleusercontent.com',
    iosClientId: '602867001820-p21jqotknhl6gcinm7lv9tmubhv30gh9'
        '.apps.googleusercontent.com',
    iosBundleId: 'dev.flutterconke.fluttercon',
  );
}
