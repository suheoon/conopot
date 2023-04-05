import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB20SZ0PatB3uuAys0o6-BKu_oqKaDUI2g',
    appId: '1:776980976362:android:44efd06c241072c10c3d93',
    messagingSenderId: '776980976362',
    projectId: 'conopot',
    storageBucket: 'conopot.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8gytoBpoBR0VFr3pr_j16LD74OVtlmI0',
    appId: '1:776980976362:ios:abbf48a78d3bfff00c3d93',
    messagingSenderId: '776980976362',
    projectId: 'conopot',
    storageBucket: 'conopot.appspot.com',
    iosClientId: '776980976362-b63us9qaf5s86smgbdchkil7reafeq23.apps.googleusercontent.com',
    iosBundleId: 'com.swmaestro.conopot',
  );
}
